module thing;

//version = PopUps;

import base;

struct Thing {
private:
	Point _pos, _destPos, _dir;
	float _angle = 0f;
	bool _atDest;
	JText _txtid;
	static int _markerID = 1;
	int _id;
public:
	Point pos() { return _pos; }
	void pos(Point pos0) { _pos = pos0; }
	Point destPos() { return _destPos; }
	void destPos(Point destPos0) { _destPos = destPos0; }
	Point dir() { return _dir; }
	void dir(Point dir0) { _dir = dir0; }

	this(int id, Point pos0, Point destPos0, Point dir = Point(0, 0)) {
		_pos = pos0;
		_destPos = destPos0;
		_dir = dir;
		_id = _markerID;
		_markerID += 1;
		_id = id;
		//this(string message, SDL_Rect r, SDL_Color col, int fontSize, string fileName) {

		//_txtid = JText(text(_id), SDL_Rect(0,0,0,0), SDL_Color(255,255,255), 20, "DejaVuSans.ttf");
		//_id.gh;
	}

	void aim(AimState state, Point max = Point(0,0)) {
		float ax, ay;
		final switch(state) {
			case AimState.normal:
				xyaim(ax, ay, getAngle(_pos.X, _pos.Y, _destPos.X, _destPos.Y));
				_dir = Point(ax, ay);
			break;
			case AimState.uniform:
				xyaim(ax, ay, getAngle(_pos.X, _pos.Y, _destPos.X, _destPos.Y));
				_dir = Point(ax * max.X, ay * max.Y);
			break;
		}
	}

	void process() {
		if (approxEqual(_pos.X, _destPos.X, -0.9, 0.9) && approxEqual(_pos.Y, _destPos.Y, -0.9, 0.9)) {
			_pos = _destPos;
			_atDest = true;
			return;
		}

		//float ax, ay;
		//xyaim(&ax, &ay, getAngle(_pos.X, _pos.Y, _destPos.X, _destPos.Y));
		//_pos += Point(ax, ay);
		_pos += Point(_dir.X, _dir.Y);

		if (g_rotate) {
			_angle += g_rotateSpeed;
		}
	}

	void draw(bool justNum = false) {
		if (justNum) {
			//_txtid.position = Vector2f(_pos.X - g_sprite.getLocalBounds.width + (g_sprite.getLocalBounds.width + _txtid.getLocalBounds.width) / 2 ,
			//_pos.Y + g_sprite.getLocalBounds.height / 2);
			/+
			_txtid.pos = Point(_pos.X - SCREEN_WIDTH + (g_sprite.mRect.w + _txtid.mRect.w) / 2,
				(_pos.Y - g_sprite.mRect.h + (g_sprite.mRect.h + _txtid.mRect.h) / 2));
			_txtid.draw(gRenderer);
			+/
			return;
		}
		g_sprite.pos = Point(_pos.X, _pos.Y);
		//g_sprite.origin = Vector2f(g_sprite.getLocalBounds.width / 2, g_sprite.getLocalBounds.height / 2);
		//g_sprite.rotation = _angle;
		version(PopUps) {
			if (_atDest)
				g_sprite.draw;
		} else {
			g_sprite.draw;
			//if (g_showNum)
			//	g_window.draw(_txtid);
		}
	}

	string toString() {
		return format("Current pos Point(%s, %s)/Target pos Point(%s, %s)", pos.X, pos.Y, destPos.X, destPos.Y);
	}
}
