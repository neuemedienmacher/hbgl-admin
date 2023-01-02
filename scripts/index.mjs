import { readFileSync, writeFileSync } from 'node:fs';
import translate from 'translate';
import PromiseQueue from 'p-queue';
import { parse } from 'csv-parse/sync';
import { stringify } from "csv-stringify";

const log = console.log;
const error = console.error;

translate.key = '';
translate.from = 'de';
translate.engine = 'google';

const TEST_LENGTH = null;
const LANGUAGES_TO_TRANSLATE = ['uk', 'ru'];

const translateString = async (key, valueToTranslate, locale) => {
  // log(`Translating into ${locale}`, key, valueToTranslate);
  if (valueToTranslate === 'NULL' || valueToTranslate === '') return { key, translatedValue: '' };

  const translatedValue = await translate(valueToTranslate, { to: locale })

  return {
    key,
    translatedValue
  }
}


const translateContent = async (row, keysToTranslate, locale, idx) => {
  log('translating text in row: ', idx, ' with locale: ', locale);
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
    offer_id: Number(row.offer_id),
    locale,
  };

  return {
    ...base,
    ...transformedResult
  }
}

const loadAndParseInputFile = () => {
  try {
    const raw = readFileSync('./offer_translations_input.csv', {encoding: 'utf8'});
    return parse(raw, {columns: true, skip_empty_lines: true});
  } catch(e) {
    console.error('Error loading and parsing input file');
    console.error(e);
    process.exit(1);
  }
};

const prepareTranslationRequests = (csvData) => {
  const out = [];
  csvData.every((row, idx) => {
    if (TEST_LENGTH && idx > TEST_LENGTH) return false;
    LANGUAGES_TO_TRANSLATE.forEach(locale => {
      out.push(async () => translateContent(row, ['name', 'description', 'old_next_steps', 'opening_specification'], locale, idx))
    });
    return true;
  });

  return out;
};

const createCsvOutput = async (data) => {
  return new Promise((resolve, reject) => {
    stringify(data, { cast: { boolean: (value, context) => { return (value) ? 'true' : 'false'; }}, header: true, quoted_empty: false, quoted_string: true }, (err, result) => {
      if (err) return reject(err);
      resolve(result);
    })
  })
}

const main = async () => {
  const queue = new PromiseQueue({ concurrency: 1 });

  const parsedCsv = loadAndParseInputFile();

  const translationPromises = prepareTranslationRequests(parsedCsv);

  const res = await queue.addAll(translationPromises);

  const finalContent =  res.map(row => ({
    offer_id: row.offer_id,
    locale: row.locale,
    source: 'GoogleTranslate',
    created_at: (new Date()).toISOString(),
    updated_at: (new Date()).toISOString(),
    name: row.name,
    description: row.description,
    old_next_steps: row.old_next_steps,
    opening_specification: row.opening_specification,
    possibly_outdated: false }))

  //log(finalContent);
  const csvOutput = await createCsvOutput(finalContent);

  writeFileSync('output.csv', csvOutput);

  return;
};


main();
