(() => {
  // Theme switch
  const body = document.body;
  const lamp = document.getElementById("mode");
  const preference = window.matchMedia("(prefers-color-scheme:dark)").matches ? "dark" : "light";
  const setting = localStorage.getItem("theme");

  const setTheme = (state) => {
    if (state === "light") {
      body.removeAttribute("data-theme");
    } else if (state === "dark") {
      body.setAttribute("data-theme", "dark");
    }
  };

  if (setting !== null) {
    setTheme(setting);
  } else {
    setTheme(preference);
  }

  lamp.addEventListener("click", () => {
    const theme = document.body.getAttribute("data-theme") ? 'light' : 'dark'
    localStorage.setItem("theme", theme);
    setTheme(theme);
  });

  setTimeout(() => body.classList.remove("notransition"), 75);

  // Blur the content when the menu is open
  const cbox = document.getElementById("menu-trigger");

  cbox.addEventListener("change", function () {
    const area = document.querySelector(".wrapper");
    this.checked
      ? area.classList.add("blurry")
      : area.classList.remove("blurry");
  });
})();
