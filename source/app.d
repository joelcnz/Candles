/+
Candle count program

sprite goes around and a round in a circle

And you can type stuff in at the prompt.
+/

//#not the best

module main;

import std.math, std.file, std.range;

import base, thing, thingman;

Image texture;

int main(string[] args) {
	if (g_setup.psetup(args) != 0) {
		gh("Setup error, aborting...");

		return -1;
	}

	scope(exit)
		g_setup.shutdown;

//	g_window.setFramerateLimit(120);
	
	// load a image file for ozbject
//	texture = new Texture;
	loadItem(g_image);
//	texture = Image(g_image);

	// Setup picture let sprite object using texture object
//	g_sprite = new Sprite(texture);

	bool _input;
	
	ThingMan thgs;
	thgs.setup;

	Wedget[] itemWedgets;
	itemWedgets ~= new Wedget("objects", JRectangle(SDL_Rect(20,20,300, 20), BoxStyle.solid, SDL_Color(255,128,0)));
	foreach(y, label; g_items) {
		import std.path;

		itemWedgets ~= new Button(label, JRectangle(SDL_Rect(20,45 + cast(int)y * 25,300, 20), BoxStyle.solid, SDL_Color(255,128,0)),
			label.stripExtension.baseName.to!string);
	}

	g_guiButtons.setup(itemWedgets);

	with(g_guiButtons.getWedgets[WedgetNum.objectsTitle]) {
		list = ["Graphic button list:"];
		focusAble = false;
	}
	int mx, my;
	bool done = false;
    while(! done)
    {
		//Handle events on queue
		while( SDL_PollEvent( &gEvent ) != 0 ) {
			//User requests quit
			if (gEvent.type == SDL_QUIT)
				done = true;
		}

		SDL_PumpEvents();
		SDL_GetMouseState(&mx, &my);

		if (! _input) {
			if (g_keys[SDL_SCANCODE_SPACE].keyInput) {
				if (g_order == Phase.lineUp) {
					g_order = Phase.circle;
					thgs.setupOrder;
				} else if (g_order == Phase.circle) {
					g_order = Phase.point;
					thgs.setupOrder;
				} else if (g_order == Phase.point) {
					g_order = Phase.lineUp;
					thgs.setupOrder;
				}
			}

			if (g_keys[SDL_SCANCODE_T].keyInput) {
				_input = ! _input;
			}
		}

		if (_input)
			jx.process; //#input

		if (jx.enterPressed && jx.textStr.length) {
			int number;
			float floatnum;
			jx.enterPressed = false;
			auto line = jx.textStr;
			jx.textStr = "";
			jx.xpos = 0;
			jx.updateMeasure;

			dstring key;
			try {
				key = line.split[0];
			} catch(Exception e) {
				jx.addToHistory("Invalid input..");
				//#not the best
			}
			dstring value;
			if (key.length < line.length) {
				value = line[key.length + 1 .. $];
				try
					floatnum = value.to!float;
				catch(Exception e)
					jx.addToHistory("'", value, "' error");
				if (! value.canFind("."))
					number = floatnum.to!int;
			}

			switch(key) {
				case "help":
					["Commands:",
						"cls/clear - clear above",
						"n/number # - change number of things",
						"t - close input",
						"quit - exit Candles",
						"r - rotate/not rotate toggle",
						"list - list items",
						"load # - load item",
						"id - toggle id nums displayed",
						"centre # - (1-5) big bang",
						"info - information",
						"spread - over screen",
						"radw - radius width",
						"radh - radius height",
						"*rotCir - rotate circle increment",
						"rotspd # - rotate speed",
						"gui - toggle graphical user interface on/off",
						"* - under construction"].
						each!(t => jx.addToHistory(t));
				break;
				case "rotspd":
					g_rotateSpeed = floatnum;
				break;
				case "rotCir":
					g_rotateCircle = floatnum;
				break;
				case "radw", "radiusw":
					g_radiusw = number;
				break;
				case "radh", "radiush":
					g_radiush = number;
				break;
				case "spread":
					thgs.spread;
				break;
				case "info", "information":
					with(jx) {
						addToHistory("Information:");
						addToHistory("Age: ", g_age.addCommas);
						addToHistory("Rotate: ", g_rotate);
						addToHistory("Rotate Speed: ", g_rotateSpeed);
						addToHistory("Show ID: ", g_showNum);
						addToHistory("Image: ", g_image);
						addToHistory("Shape: ", g_order);
					}
				break;
				case "cls", "clear":
					jx.clearHistory;
				break;
				case "centre":
					float[12] sp = [0,0, 0,0, 1,0, 0,1, 1,1, 0.5,0.5];
					if (number < 1 && number * 2 >= sp.length) {
						jx.addToHistory("Invalid number");
						break;
					}

					thgs.centre( Point(sp[number * 2] * SCREEN_WIDTH,
						sp[number * 2 + 1] * SCREEN_HEIGHT));
				break;
				case "id":
					g_showNum = ! g_showNum;// == false ? true : false;
				break;
				case "list":
					foreach(i, name; g_items)
						jx.addToHistory(text(i + 1, ") ", name));
				break;
				case "load":
					if (number < 1 || number > g_items.length) {
						jx.addToHistory("No such file");
					} else {
						string itemFile = g_items[number - 1];
						loadItem(itemFile);
					}
				break;
				case "n", "number":
					//g_age = number;
					thgs.clear;
					g_age = number;
					thgs.setupOrder;
				break;
				case "t":
					_input = false;
				break;
				default:
					jx.addToHistory("What?");
				break;
				case "q", "quit":
					done = true;
				break;
				case "r":
					g_rotate = ! g_rotate;
				break;
				case "hey":
					jx.addToHistory("Hi.");
				break;
				case "gui":
					g_guiButtonsToggle = ! g_guiButtonsToggle;
				break;
			}
		}

		thgs.process;
		if (g_guiButtonsToggle) {
			string item;
			g_guiButtons.process(item);
			if (item.length)
				loadItem(item);
		}

        SDL_SetRenderDrawColor(gRenderer, 0x00, 0x00, 0x00, 0x00);
        SDL_RenderClear(gRenderer);

		thgs.draw;
		if (_input)
			jx.draw;
		if (g_guiButtonsToggle)
			g_guiButtons.draw;

    	SDL_RenderPresent(gRenderer);
    } // while ! done
	
	return 0;
}

void loadItem(in string itemFile) {
	import std.path : buildPath;
	import std.file : exists;
	import std.string : split;
	import std.algorithm : each;

	string fileex;
	void ifexists(in string fnex) {
		if (exists(buildPath("Items", itemFile ~ fnex)))
			fileex = fnex;
	}
	".jpg .png".split.each!(fn => ifexists(fn));
	immutable wholeName = buildPath("Items", itemFile ~ fileex);
	if (! exists(wholeName)) {
		(wholeName ~ " - fail").gh;
		return; // if file missing or some thing it closes the program (maybe should put 'window.close;')
	}
	
	// Setup picture let sprite object using texture object
	g_sprite = Image(wholeName);
	jx.addToHistory(text("Loaded ", wholeName));
	g_image = itemFile;
}
