module guibuttons;

import base;

struct GuiButtons {
    Wedget[] _wedgets;

    ref auto getWedgets() {
        return _wedgets;
    }

    void setup(Wedget[] wedgets) {
        _wedgets = wedgets;
    }

    void process(out string item) {
        auto pos = Mouse.getPosition(g_window);
        auto cursor = Point(pos.x, pos.y);

        foreach(ref wedget; _wedgets) with(wedget) {
            process;
            if (gotFocus(cursor)) {
                _focus = Focus.on;
                if (g_keys[Keyboard.Key.V].keyTrigger) {
                    item = txtHead;
                }
            } else {
                _focus = Focus.off;
            }
        }
    }

    void draw() {
        foreach(wedget; _wedgets)
            wedget.draw;
    }
}
