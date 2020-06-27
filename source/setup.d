module psetup;

import base;

/// Main setup struct
struct Setup {
private:
    string _settingsFileName;
    string _current;
public:
    int psetup(string[] args = []) {
        import jecsdl, jmisc;

        setSettingsFileName("settings.ini");
        assert(fileNameExists, _settingsFileName ~ " not found");
        loadSettings;

        //SCREEN_WIDTH = 640; SCREEN_HEIGHT = 480;
        //SCREEN_WIDTH = 2560; SCREEN_HEIGHT = 1600;
        SCREEN_WIDTH = 1280; SCREEN_HEIGHT = 800;
        if (setup("Poorly Programmed Producions - Presents: Vac Space",
            SCREEN_WIDTH, SCREEN_HEIGHT,
            SDL_WINDOW_SHOWN
            //SDL_WINDOW_OPENGL
            //SDL_WINDOW_FULLSCREEN_DESKTOP
            //SDL_WINDOW_FULLSCREEN
            ) != 0) {
            writeln("Init failed");
            return 1;
        }

        const ifontSize = 12;
        jx = new InputJex(Point(0, SCREEN_HEIGHT - ifontSize - ifontSize / 4), ifontSize, "'help' for help>",
            InputType.history);
    
        jx.addToHistory(""d);

        //g_thgs.setup;

        //g_mode = Mode.edit;
    	g_terminal = true;

        return 0;
    }

    void shutdown() {
        saveSettings;
        SDL_DestroyRenderer(gRenderer),
        SDL_Quit();
    }
    
    void setSettingsFileName(in string fileName) {
        _settingsFileName = fileName;
    }

    bool fileNameExists() {
        import std.file : exists;

        return exists(_settingsFileName); 
        //if (! exists(_settingsFileName))
        //    return false;
        //else
        //    return true;
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