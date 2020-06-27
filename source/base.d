module base;

public:
import std.stdio, std.conv, std.algorithm, std.string;

import jecsdl, dini.dini, jmisc;

import psetup, guibuttons;

Setup g_setup;
int gFontSize = 12;

alias jx = g_inputJex;

Image g_sprite;

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

shared static this() {
    import std.file;
    import std.path;

    foreach(string name; dirEntries("Items", "*.{png,jpg}", SpanMode.shallow))
        g_items ~= name.baseName.stripExtension;
}