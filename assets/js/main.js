(() => {
  // Theme switch
  const body = document.body;
  const lamp = document.getElementById("mode");
  console.log('here');

  const setTheme = (state) => {
    if (state === "light") {
      localStorage.setItem("theme", "light");
      body.removeAttribute("data-theme");
    } else if (state === "dark") {
      localStorage.setItem("theme", "dark");
      body.setAttribute("data-theme", "dark");
    }
  };

  lamp.addEventListener("click", () => {
    setTheme(document.body.getAttribute("data-theme") ? 'light' : 'dark');
  });

  // Blur the content when the menu is open
  const cbox = document.getElementById("menu-trigger");

  cbox.addEventListener("change", function () {
    const area = document.querySelector(".wrapper");
    this.checked
      ? area.classList.add("blurry")
      : area.classList.remove("blurry");
  });
})();
