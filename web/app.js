const containers = {
  "top-right": document.getElementById("top-right"),
  "top-left": document.getElementById("top-left"),
  "top-center": document.getElementById("top-center"),
  "bottom-right": document.getElementById("bottom-right"),
  "bottom-left": document.getElementById("bottom-left"),
  "bottom-center": document.getElementById("bottom-center"),
};

const iconMap = {
  success: "circle-check",
  error: "circle-x",
  warning: "triangle-alert",
  info: "info",
  police: "shield",
  money: "badge-dollar-sign",
  vehicle: "car-front",
  social: "users",
  location: "map-pinned",
  phone: "phone",
  mechanic: "wrench",
  health: "heart",
  death: "skull",
  achievement: "star",
  timer: "timer",
  mission: "zap",
};

function normalizeIconName(name) {
  if (typeof name !== "string") {
    return "";
  }

  return name
    .trim()
    .replace(/_/g, "-")
    .replace(/([a-z0-9])([A-Z])/g, "$1-$2")
    .toLowerCase();
}

function toLucideKey(name) {
  const normalized = normalizeIconName(name);
  if (!normalized) {
    return "";
  }

  return normalized
    .split("-")
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("");
}

function hasLucideIcon(name) {
  const key = toLucideKey(name);
  return Boolean(key && window.lucide?.icons?.[key]);
}

function resolveIconName(data) {
  const customIcon = normalizeIconName(data.icon);
  if (customIcon && hasLucideIcon(customIcon)) {
    return customIcon;
  }

  const mappedIcon = normalizeIconName(iconMap[data.type]);
  if (mappedIcon && hasLucideIcon(mappedIcon)) {
    return mappedIcon;
  }

  return "info";
}

function getContainer(position) {
  return containers[position] || containers["top-right"];
}

function getEnterClass(position) {
  if (position === "top-left") return "left-enter";
  if (position === "top-center") return "top-center-enter";
  if (position === "bottom-right") return "bottom-right-enter";
  if (position === "bottom-left") return "bottom-left-enter";
  if (position === "bottom-center") return "bottom-center-enter";
  return "";
}

function removeOverflow(container, maxVisible) {
  while (container.children.length > maxVisible) {
    const target = container.lastElementChild;
    if (!target) break;
    removeNotification(target, true);
  }
}

function removeNotification(element, immediate = false) {
  if (!element) return;

  if (immediate) {
    if (element.parentNode) {
      element.parentNode.removeChild(element);
    }
    return;
  }

  if (element.dataset.removing === "true") return;

  element.dataset.removing = "true";
  element.classList.add("removing");

  setTimeout(() => {
    if (element.parentNode) {
      element.parentNode.removeChild(element);
    }
  }, 220);
}

function applyLucideIcons(scope) {
  if (!scope || !window.lucide?.createIcons || !window.lucide?.icons) {
    return;
  }

  window.lucide.createIcons({
    icons: window.lucide.icons,
    root: scope,
  });
}

function startProgressAnimation(progressEl, duration) {
  if (!progressEl) return;

  progressEl.style.transition = "none";
  progressEl.style.transform = "scaleX(1)";

  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      progressEl.style.transition = `transform ${duration}ms linear`;
      progressEl.style.transform = "scaleX(0)";
    });
  });
}

function createNotification(data) {
  const notify = document.createElement("div");
  notify.className =
    `notify ${data.type} ${getEnterClass(data.position)}`.trim();

  if (data.id) {
    notify.dataset.id = data.id;
  }

  const glowLine = document.createElement("div");
  glowLine.className = "notify-glow-line";

  const inner = document.createElement("div");
  inner.className = "notify-inner";

  const iconWrap = document.createElement("div");
  iconWrap.className = "notify-icon-wrap";

  const iconGlow = document.createElement("div");
  iconGlow.className = "notify-icon-glow";

  const icon = document.createElement("div");
  icon.className = "notify-icon";

  const iconName = resolveIconName(data);
  icon.innerHTML = `<i data-lucide="${iconName}"></i>`;

  iconWrap.appendChild(iconGlow);
  iconWrap.appendChild(icon);

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

  const close = document.createElement("button");
  close.className = "notify-close";
  close.type = "button";
  close.innerHTML = `<i data-lucide="x"></i>`;
  close.onclick = () => removeNotification(notify);

  inner.appendChild(iconWrap);
  inner.appendChild(content);
  inner.appendChild(close);

  notify.appendChild(glowLine);
  notify.appendChild(inner);

  if (!data.persistent && data.progress !== false) {
    const track = document.createElement("div");
    track.className = "notify-progress-track";

    const progress = document.createElement("div");
    progress.className = "notify-progress";

    track.appendChild(progress);
    notify.appendChild(track);

    notify._progressEl = progress;
  }

  return notify;
}

function insertNotification(data) {
  const position = data.position || "top-right";
  const container = getContainer(position);
  const maxVisible = Number(data.maxVisible) || 5;

  if (data.id) {
    const escaped =
      typeof CSS !== "undefined" && CSS.escape ? CSS.escape(data.id) : data.id;
    const existing = container.querySelector(`[data-id="${escaped}"]`);
    if (existing) existing.remove();
  }

  const notify = createNotification(data);

  if (position.startsWith("bottom")) {
    container.appendChild(notify);
  } else {
    container.prepend(notify);
  }

  setTimeout(() => {
    applyLucideIcons(notify);

    if (notify._progressEl && !data.persistent && data.progress !== false) {
      startProgressAnimation(notify._progressEl, data.duration);
    }
  }, 0);

  if (!data.persistent && data.progress !== false) {
    setTimeout(() => {
      removeNotification(notify);
    }, data.duration);
  }

  removeOverflow(container, maxVisible);
}

window.addEventListener("message", (event) => {
  const data = event.data;
  if (!data || data.action !== "notify" || !data.payload) return;
  insertNotification(data.payload);
});
