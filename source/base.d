module base;

public:
import std.stdio, std.conv, std.algorithm, std.string;

import dsfml.window;
import dsfml.graphics;
import dsfml.audio;

import jec, dini.dini, jmisc;

import setup, guibuttons;

Setup g_setup;

alias jx = g_inputJex;

Sprite g_sprite;

enum Phase {point, lineUp, circle, triangle, square}
enum AimState {normal, uniform}
enum WedgetNum {objectsTitle}

WedgetNum g_wedgetNum;

GuiButtons g_guiButtons;

int g_age;
bool g_rotate;
bool g_showNum;
string g_image;
Phase g_order;
int g_radiusw,
    g_radiush;
float g_rotateCircle;
float g_rotateSpeed;
bool g_guiButtonsToggle;

string[] g_items;

static this() {
    import std.file;

    foreach(string name; dirEntries("Items", "*.{png,jpg}", SpanMode.shallow))
        g_items ~= name;
}