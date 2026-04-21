const containers = {
  "top-right": document.getElementById("top-right"),
  "top-left": document.getElementById("top-left"),
  "bottom-right": document.getElementById("bottom-right"),
  "bottom-left": document.getElementById("bottom-left"),
};

const iconMap = {
  success: "✓",
  error: "✕",
  warning: "!",
  info: "i",
};

function getContainer(position) {
  return containers[position] || containers["top-right"];
}

function removeOverflow(container, maxVisible) {
  while (container.children.length > maxVisible) {
    const target = container.lastElementChild;
    if (target) {
      target.remove();
    } else {
      break;
    }
  }
}

function removeNotification(element) {
  if (!element || element.dataset.removing === "true") {
    return;
  }

  element.dataset.removing = "true";
  element.classList.add("removing");

  setTimeout(() => {
    if (element && element.parentNode) {
      element.parentNode.removeChild(element);
    }
  }, 180);
}

function createNotification(data) {
  const notify = document.createElement("div");
  notify.className = `notify ${data.type}`;

  if (data.position && data.position.startsWith("bottom")) {
    notify.classList.add("bottom");
  }

  if (data.id) {
    notify.dataset.id = data.id;
  }

  const icon = document.createElement("div");
  icon.className = "notify-icon";
  icon.textContent = iconMap[data.type] || iconMap.info;

  const content = document.createElement("div");
  content.className = "notify-content";

  const title = document.createElement("div");
  title.className = "notify-title";
  title.textContent = data.title || "Notificação";

  const message = document.createElement("div");
  message.className = "notify-message";
  message.textContent = data.message || "";

  content.appendChild(title);
  content.appendChild(message);

  notify.appendChild(icon);
  notify.appendChild(content);

  if (!data.persistent) {
    const progress = document.createElement("div");
    progress.className = "notify-progress";
    progress.style.transition = `transform ${data.duration}ms linear`;

    notify.appendChild(progress);

    requestAnimationFrame(() => {
      progress.style.transform = "scaleX(0)";
    });

    setTimeout(() => {
      removeNotification(notify);
    }, data.duration);
  }

  return notify;
}

function insertNotification(data) {
  const position = data.position || "top-right";
  const container = getContainer(position);
  const maxVisible = Number(data.maxVisible) || 4;

  if (data.id) {
    const existing = container.querySelector(
      `[data-id="${CSS.escape(data.id)}"]`,
    );
    if (existing) {
      existing.remove();
    }
  }

  const notify = createNotification(data);
  container.prepend(notify);
  removeOverflow(container, maxVisible);
}

window.addEventListener("message", (event) => {
  const data = event.data;

  if (!data || data.action !== "notify" || !data.payload) {
    return;
  }

  insertNotification(data.payload);
});
