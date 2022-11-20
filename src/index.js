const DEFAULT_THEME = 'light'

document.addEventListener('DOMContentLoaded', function(){
    const body = document.body
    const logo = document.getElementById('logo');
    const switcher = document.getElementById('theme-switcher');

    // Select the theme preference from localStorage
    let theme = localStorage.getItem('theme') ?? DEFAULT_THEME;

    // If the current theme in localStorage is 'dark'...
    if (theme == 'dark') {
      // ...then use the .dark-theme class
      body.classList.add('dark-theme');
      logo.src = `img/google-${theme}.png`;
    }

    // Listen for a click on the switcher
    switcher.addEventListener('change', function() {
        console.log(`Changing from ${theme} theme`);
        theme = theme !== DEFAULT_THEME ? DEFAULT_THEME : 'dark';
        console.log(`to ${theme} theme.`);

        body.classList.toggle('dark-theme');
        logo.src = `img/google-${theme}.png`;
        localStorage.setItem('theme', theme);
    })
});
