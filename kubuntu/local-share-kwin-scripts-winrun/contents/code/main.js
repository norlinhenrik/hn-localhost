print("WINRUN SCRIPT LOADED");

/*
 * CONFIG
 */
var STATE_FILE = "/home/henrik/.cache/winrun/windows.json";

/*
 * FILE IO (Qt API)
 */
function readFile(path) {
    var file = new QFile(path);

    if (!file.open(QIODevice.ReadOnly)) {
        return {};
    }

    var stream = new QTextStream(file);
    var content = stream.readAll();
    file.close();

    try {
        return JSON.parse(content);
    } catch (e) {
        return {};
    }
}

function writeFile(path, data) {
    var file = new QFile(path);

    if (!file.open(QIODevice.WriteOnly | QIODevice.Truncate)) {
        print("Failed to open file for writing:", path);
        return;
    }

    var stream = new QTextStream(file);
    stream.writeString(JSON.stringify(data, null, 2));
    file.close();
}

/*
 * KEYWORD MAPPING (tilpass dette!)
 */
function getKeyword(window) {
    if (!window.caption) return null;

    var caption = window.caption.toLowerCase();

    // 🔥 EKSEMPEL: Brave profiler
    if (caption.includes("profile_privat")) {
        return "brave-privat";
    }

    if (caption.includes("profile_work")) {
        return "brave-work";
    }

    // fallback: bruk caption
    return window.caption;
}

/*
 * WINDOW TRACKING
 */
workspace.windowAdded.connect(function(window) {
    if (!window || !window.caption) return;

    print("NEW WINDOW:", window.caption);

    // filtrer apps (valgfritt)
    if (window.resourceClass &&
        !window.resourceClass.toLowerCase().includes("brave")) {
        return;
        }

        var keyword = getKeyword(window);
    if (!keyword) return;

    var state = readFile(STATE_FILE);

    state[keyword] = {
        caption: window.caption,
        pid: window.pid,
        resourceClass: window.resourceClass,
        internalId: window.internalId
    };

    writeFile(STATE_FILE, state);

    print("Stored window:", keyword);
});

/*
 * CLEANUP når vindu lukkes
 */
workspace.windowRemoved.connect(function(window) {
    var state = readFile(STATE_FILE);
    var changed = false;

    for (var key in state) {
        if (state[key].pid === window.pid) {
            delete state[key];
            changed = true;
            print("Removed window:", key);
        }
    }

    if (changed) {
        writeFile(STATE_FILE, state);
    }
});

/*
 * ACTIVATE FUNCTION (DBus)
 */
function activateByKeyword(keyword) {
    print("Activate request:", keyword);

    var state = readFile(STATE_FILE);

    if (!(keyword in state)) {
        print("Keyword not found:", keyword);
        return false;
    }

    var info = state[keyword];

    var windows = workspace.windowList();

    for (var i = 0; i < windows.length; i++) {
        var w = windows[i];

        if (
            w.caption === info.caption &&
            w.resourceClass === info.resourceClass
        ) {
            workspace.activeWindow = w;
            print("Activated:", keyword);
            return true;
        }
    }

    print("Window not found for keyword:", keyword);
    return false;
}

/*
 * REGISTER DBUS INTERFACE
 */
registerDBusInterface("org.kde.KWin.winrun");
