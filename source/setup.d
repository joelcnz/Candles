module setup;

import base;

/// Main setup struct
struct Setup {
private:
    string _settingsFileName;
    string _current;
public:
    int setup(string[] args = []) {
        import jec, jmisc;

        setSettingsFileName("settings.ini");
        assert(fileNameExists, _settingsFileName ~ " not found");
        loadSettings;

        g_window = new RenderWindow(VideoMode.getDesktopMode,
                            "Welcome to Candles! Press [T] for terminal, Press [System] + [Q] to quit");

        g_font = new Font;
        g_font.loadFromFile("DejaVuSans.ttf");
        if (! g_font) {
            import std.stdio;
            writeln("Font not load");
            return -1;
        }

        g_checkPoints = true;
        if (jec.setup != 0) {
            import std.stdio : writefln;

            writefln("Error function: %s, Line: %s", __FUNCTION__, __LINE__);
            return -1;
        }

        g_inputJex = new InputJex(/* position */ Vector2f(0, g_window.getSize.y - 32),
                            /* font size */ 12,
                            /* header */ "Enter 'help': ",
                            /* Type (oneLine, or history) */ InputType.history);
    
        g_inputJex.addToHistory(""d);

        //g_thgs.setup;

        g_mode = Mode.edit;
    	g_terminal = true;

        return 0;
    }

    void shutdown() {
        saveSettings;
    }
    
    void setSettingsFileName(in string fileName) {
        _settingsFileName = fileName;
    }

    bool fileNameExists() {
        import std.file : exists;

        if (! exists(_settingsFileName))
            return false;
        else
            return true;
    }

    void saveSettings() {
        import std.stdio : File;
        import std.string : format;

        char oneorzero(bool n) { return n ? '1' : '0'; }
        auto file = File(_settingsFileName, "w");
        with(file) {
            writeln("[main]");
            writeln("age=", g_age);
            writeln("rotate=", oneorzero(g_rotate));
            writeln("rotateSpeed=", g_rotateSpeed);
            writeln("image=", g_image);
            writeln("showNum=", oneorzero(g_showNum));
            writeln("radiusw=", g_radiusw);
            writeln("radiush=", g_radiush);
            writeln("rotateCircle=", g_rotateCircle);
            writeln("guiButtonsToggle=", oneorzero(g_guiButtonsToggle));
        }
    }

    void loadSettings() {
        if (fileNameExists) {
            auto ini = Ini.Parse(_settingsFileName);

            bool ifzero(string a) { return a == "1"; } 
            g_age = ini["main"].getKey("age").to!int;
            g_rotate = ifzero(ini["main"].getKey("rotate"));
            g_rotateSpeed = ini["main"].getKey("rotateSpeed").to!float;
            g_image = ini["main"].getKey("image");
            g_showNum= ifzero(ini["main"].getKey("showNum"));
            g_radiusw = ini["main"].getKey("radiusw").to!int;
            g_radiush = ini["main"].getKey("radiush").to!int;
            g_rotateCircle = ini["main"].getKey("rotateCircle").to!float;
            g_guiButtonsToggle = ifzero(ini["main"].getKey("guiButtonsToggle"));
        }
    }
}