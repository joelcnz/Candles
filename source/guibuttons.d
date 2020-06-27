//#it repeats!
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
        int mx, my;
        SDL_GetMouseState(&mx, &my);
        auto cursor = Point(mx, my);

        foreach(ref wedget; _wedgets) with(wedget) {
            process;
            if (gotFocus(cursor)) {
                _focus = Focus.on;
                //if (g_keys[SDL_SCANCODE_V].keyTrigger) {
                if (gEvent.type == SDL_MOUSEBUTTONDOWN) {
                    item = txtHead;
                    //#it repeats!
                    //while(gEvent.type == SDL_MOUSEBUTTONDOWN) { SDL_GetMouseState(&mx, &my); }
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
