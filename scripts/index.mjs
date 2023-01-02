import { readFileSync, writeFileSync } from 'node:fs';
import translate from 'translate';
import PromiseQueue from 'p-queue';
import { parse } from 'csv-parse/sync';
import { stringify } from 'csv-stringify';
import { Command } from 'commander';
import { fileURLToPath } from 'node:url';
import { dirname } from 'node:path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const log = console.log;
const error = console.error;

translate.key = '';
translate.from = 'de';
translate.engine = 'google';

const TEST_LENGTH = null;
const LANGUAGES_TO_TRANSLATE = ['uk', 'ru'];

const program = new Command();

program
  .name('hbgl batch translate')
  .description('translate csv sources via google translate api')
  .requiredOption('-t, --type <type>','input filetype must be defined')
  .requiredOption('-p, --path <filepath>', 'input file must be defined')



const valueIsEmpty = (val) => {
  return val === 'NULL' || val === '';
}

const translateString = async (key, valueToTranslate, locale) => {
  // log(`Translating into ${locale}`, key, valueToTranslate);
  if (valueIsEmpty(valueToTranslate)) return { key, translatedValue: '' };

  const translatedValue = await translate(valueToTranslate, { to: locale })

  return {
    key,
    translatedValue
  }
}


const translateContent = async (row, pk, keysToTranslate, locale, idx) => {
  log('translating text in row: ', { idx, pk, locale }, ' and keys to translate: ', keysToTranslate);
  const translatePromises = [];
  keysToTranslate.forEach(key =>
    translatePromises.push(translateString(key, row[key], locale))
  )

  const result = await Promise.all(translatePromises);

  const transformedResult = result.reduce((acc, cur) => {
    return {
      ...acc,
      [cur.key]: cur.translatedValue
    }

  }, {})

  const base = {
    [pk]: Number(row[pk]),
    locale,
  };

  return {
    ...base,
    ...transformedResult
  }
}

const loadAndParseInputFile = (filePath) => {
  try {
    const raw = readFileSync(__dirname + '/' + filePath, {encoding: 'utf8'});
    return parse(raw, {columns: true, skip_empty_lines: true});
  } catch(e) {
    console.error('Error loading and parsing input file');
    console.error(e);
    process.exit(1);
  }
};

const PRIMARY_KEYS_MAP = {
  contact_person: 'contact_person_id',
  offer: 'offer_id',
  organization: 'organization_id'
}
const TRANSLATABLE_KEYS_MAP = {
  contact_person: ['responsibility'],
  offer: ['name', 'description', 'old_next_steps', 'opening_specification'],
  organization: ['description']
}

const prepareTranslationRequests = (csvData, type) => {
  const keysToTranslate = TRANSLATABLE_KEYS_MAP[type];
  if (!keysToTranslate) {
    error('Translation type unknown, exiting');
    process.exit(1);
  }
  const out = [];
  csvData.every((row, idx) => {
    if (TEST_LENGTH && idx > TEST_LENGTH) return false;
    LANGUAGES_TO_TRANSLATE.forEach(locale => {
      out.push(async () => translateContent(row, PRIMARY_KEYS_MAP[type],keysToTranslate, locale, idx))
    });
    return true;
  });

  return out;
};

const createCsvOutput = async (data) => {
  return new Promise((resolve, reject) => {
    stringify(data, { cast: { boolean: (value, context) => { return (value) ? 'true' : 'false'; }}, header: true, quoted_empty: true, quoted_string: true }, (err, result) => {
      if (err) return reject(err);
      resolve(result);
    })
  })
}

const TRANSLATION_RESPONSE_MAPPING = {
  contact_person: (row) => ({
    contact_person_id: row.contact_person_id,
    locale: row.locale,
    source: 'GoogleTranslate',
    created_at: (new Date()).toISOString(),
    updated_at: (new Date()).toISOString(),
    responsibility: row.responsibility
  }),
  offer: (row) => ({
    offer_id: row.offer_id,
    locale: row.locale,
    source: 'GoogleTranslate',
    created_at: (new Date()).toISOString(),
    updated_at: (new Date()).toISOString(),
    name: row.name,
    description: row.description,
    old_next_steps: row.old_next_steps,
    opening_specification: row.opening_specification,
    possibly_outdated: false
  }),
  organization: (row) => ({
    organization_id: row.organization_id,
    locale: row.locale,
    source: 'GoogleTranslate',
    created_at: (new Date()).toISOString(),
    updated_at: (new Date()).toISOString(),
    description: row.description,
    possibly_outdated: false
  }),
}

const mapTranslationResponseAndSave = async (translationResponse, type, outputPath) => {
  const responseMapper = TRANSLATION_RESPONSE_MAPPING[type];
  if (!responseMapper) {
    error('Missing response mapper for type ' + type);
    process.exit(1);
  }
  const finalContent =  translationResponse.map(responseMapper);

  const csvOutput = await createCsvOutput(finalContent);

  writeFileSync(outputPath, csvOutput);
}

const main = async () => {
  const queue = new PromiseQueue({ concurrency: 1 });

  program.parse();
  const { path, type } = program.opts();
  const _inputPath = `${path}.csv`;
  const _outputPath = `${path.replace('input', 'output')}.csv`;

  const parsedCsv = loadAndParseInputFile(_inputPath);
  const translationPromises = prepareTranslationRequests(parsedCsv, type);
  const res = await queue.addAll(translationPromises);
  await mapTranslationResponseAndSave(res, type, _outputPath);

  return;
};


main();
