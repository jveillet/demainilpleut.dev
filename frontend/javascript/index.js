
import 'index.scss';

// Import all javascript files from src/_components
const componentsContext = require.context('bridgetownComponents', true, /.js$/);
componentsContext.keys().forEach(componentsContext);

var PAGES = ['archives', 'styleguide', 'authors'];

/**
 * Add Click event on the Menu based on a selector.
 * @params {string} [selector] A DOMString containing one selector to match.
 *                             This string must be a valid CSS selector string.
 * @returns {void}
 */
function addMenuClickEvent(selector) {
    // var element = document.querySelector(selector);
    document.querySelector(selector).addEventListener('click', menuEventHandler);
}

/**
 * Add Click event on the theme switcher toggle.
 * @params {void}
 * @returns {void}
 */
function addThemeToggleClickEvent() {
    var element = document.querySelector('.js-theme-toggle');
    element.addEventListener('click', function() {
        var theme = document.documentElement.getAttribute('data-theme');
        if (theme == 'dark') {
            document.documentElement.setAttribute('data-theme', 'light');
            element.innerHTML = '🌞';
            localStorage.setItem('data-theme', 'light');
            element.setAttribute('aria-label', 'Switch to dark theme');
        } else {
            document.documentElement.setAttribute('data-theme', 'dark');
            element.innerHTML = '🌙';
            localStorage.setItem('data-theme', 'dark');
            element.setAttribute('aria-label', 'Switch to light theme');
        }
    });
}

/**
 * Mobile Menu Event Handler
 * Toggles the appropriate CSS classes when menu buttons are clicked.
 * @returns {void}
 */
function menuEventHandler() {
    document.querySelector('#js-menu').classList.toggle('active');
    document.querySelector('.topbar').classList.toggle('active');
    document.querySelector('.topbar-menu-btn').classList.toggle('active');
    document.querySelector('.topbar-btn-close').classList.toggle('active');
}

/**
 * Add a visible marker on the menu item in the topbar, to know in
 * which category we are.
 * @params {string} [pathname] - An URL path.
 * @returns {void}
 */
function displayCurrentMenuItem(pathname){
    var path = pathname.split('/');
    var pageElement = null;
    if (findInArray(PAGES, path[1])) {
        pageElement = document.querySelector('.page-'+path[1]);
    }
    else {
        pageElement = document.querySelector('.page-home');
    }
    pageElement.classList.add('topbar-navigation-item-current');
}

/**
 * Returns true or false based on whether an object is found in an array.
 * @params {array} [arr] - An array where the search is happening.
 * @params {object} [obj] - An element yoy want to search.
 * @returns {boolean} true if found else false
 */
function findInArray(arr, obj) {
    return (arr.indexOf(obj) != -1);
}

/**
 * Checks if the browser has no support for .prefers-color-scheme media query.
 *
 * @params {void}
 * @returns {boolean} true if the browser has no support
 */
function hasNoPrefersColorSchemeSupport() {
    var isDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches;
    var isLightMode = window.matchMedia('(prefers-color-scheme: light)').matches;
    var isNotSpecified = window.matchMedia('(prefers-color-scheme: no-preference)').matches;
    return (!isDarkMode && !isLightMode && !isNotSpecified);
}

/**
 * Detect if the document is Ready.
 * Alternative to DOMContentLoaded.
 * Add utility classes and attach events to menu buttons.
*/
document.onreadystatechange = function () {
    if (document.readyState === 'complete') {
        document.querySelector('body').classList.add('js');
        addMenuClickEvent('.topbar-menu-btn');
        addMenuClickEvent('.topbar-btn-close');
        displayCurrentMenuItem(window.location.pathname);

        var theme = document.documentElement.getAttribute('data-theme');
        var themeToggle = document.querySelector('.js-theme-toggle');
        if (theme == 'dark') {
            themeToggle.innerHTML = '🌙';
            themeToggle.setAttribute('aria-label', 'Switch to light theme');
        } else {
            themeToggle.innerHTML = '🌞';
            themeToggle.setAttribute('aria-label', 'Switch to dark theme');
        }

        if (window.CSS && CSS.supports('color', 'var(--main-text-color)') && !hasNoPrefersColorSchemeSupport()) {
            addThemeToggleClickEvent();
        } else {
            var element = document.querySelector('.js-theme-toggle');
            element.style.display = 'none';
        }
    }
};

import 'prism.min.js';
import 'a11y-toggle.min.js';
