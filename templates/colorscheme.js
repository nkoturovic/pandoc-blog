/*
 * If a color scheme preference was previously stored,
 * select the corresponding option in the color scheme preference UI
 * unless it is already selected.
 */
function restoreColorSchemePreference() {
  const colorScheme = localStorage.getItem(colorSchemeStorageItemName);

  if (!colorScheme) {
    // There is no stored preference to restore
    return;
  }

  const option = colorSchemeSelectorEl.querySelector(`[value=${colorScheme}]`);

  if (!option) {
    // The stored preference has no corresponding option in the UI.
    localStorage.removeItem(colorSchemeStorageItemName);
    return;
  }

  if (option.selected) {  
    // The stored preference's corresponding menu option is already selected
    return;
  }

  option.selected = true;
}

/*
 * Store an event target's value in localStorage under colorSchemeStorageItemName
 */
function storeColorSchemePreference({ target }) {
  const colorScheme = target.querySelector(":checked").value;
  localStorage.setItem(colorSchemeStorageItemName, colorScheme);
}

// The name under which the user's color scheme preference will be stored.
const colorSchemeStorageItemName = "preferredColorScheme";

// The color scheme preference front-end UI.
var colorSchemeSelectorEl;

window.addEventListener('load', function () {
  colorSchemeSelectorEl = document.querySelector("#color-scheme");

  if (colorSchemeSelectorEl) {
    restoreColorSchemePreference();

    // When the user changes their color scheme preference via the UI,
    // store the new preference.
    colorSchemeSelectorEl.addEventListener("input", storeColorSchemePreference);
    document.querySelector("#cycle-colorscheme").addEventListener("click", () => {
      storeColorSchemePreference({target:document.querySelector("#color-scheme")});
    })
  }
  updateColorSchemeText()
})

function updateColorSchemeText() {
  const selectElement = document.querySelector("#color-scheme");
  const options = selectElement.options;
  
  // If there are no options, return
  if (options.length === 0) return;

  // Get the index of the currently selected option
  const selectedIndex = selectElement.selectedIndex;
  const text = selectElement.options[selectElement.selectedIndex].textContent;

  let svgName = "fi-xnsuxl-code-solid.svg"
  if (text == "Light") {
    svgName = "fi-xnsuxl-home-solid.svg"
  } else if (text == "Dark") {
    svgName = "fi-xnslxl-chevron-solid.svg"
  }

  document.querySelector("#cycle-colorscheme").innerHTML = '<img class="nav-svg" src="./img/icon/' + svgName + '"/>' + text;
}

function cycleOptions(querySelector) {
  const selectElement = document.querySelector(querySelector);
  const options = selectElement.options;
  
  // If there are no options, return
  if (options.length === 0) return;

  // Get the index of the currently selected option
  const selectedIndex = selectElement.selectedIndex;

  // Calculate the index of the next option
  const nextIndex = (selectedIndex + 1) % options.length;

  // Set the selected option
  selectElement.selectedIndex = nextIndex;  

  updateColorSchemeText()
}
