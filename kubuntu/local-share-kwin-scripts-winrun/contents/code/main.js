const fs = require("fs");

const STATE_FILE = "/home/henrik/.cache/winrun/windows.json";

function loadState() {
    try {
        return JSON.parse(fs.readFileSync(STATE_FILE));
    } catch (e) {
        return {};
    }
}

function saveState(state) {
    fs.writeFileSync(STATE_FILE, JSON.stringify(state, null, 2));
}

// 🔥 kall fra Python via qdbus
function activateByKeyword(keyword) {
    let state = loadState();
    if (!(keyword in state)) {
        return false;
    }

    let info = state[keyword];

    workspace.windowList().forEach(w => {
        if (
            w.pid === info.pid &&
            w.caption === info.caption
        ) {
            workspace.activeWindow = w;
        }
    });

    return true;
}

// 🔥 når nytt vindu opprettes
workspace.windowAdded.connect(function (window) {
    // filtrer (kun relevante apps)
    if (!window.caption) return;

    // f.eks Brave
    if (!window.resourceClass.includes("brave")) return;

    let state = loadState();

    // 🔑 UTLED KEYWORD FRA CAPTION
    let keyword = window.caption; // du kan forbedre dette

    state[keyword] = {
        pid: window.pid,
        caption: window.caption,
        internalId: window.internalId
    };

    saveState(state);
});
