export default function addFlashMessage(flashType, text) {
  return {
    type: 'ADD_FLASH_MESSAGE',
    flashType,
    text
  }
}
