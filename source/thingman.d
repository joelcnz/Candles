module thingman;

//#Triangle

import base, thing;

struct ThingMan {
	Thing[] thgs;
	Point _middlePos;
	AimState _aimState;

	void setup() {
		_middlePos = Point(g_window.size.x / 2, g_window.size.y / 2);
		setupOrder;
		//_aimState = AimState.uniform; //#not work
		_aimState = AimState.normal;
	}

	void spread() {
		int total = g_window.size.x * g_window.size.y;
		int unit = total / g_age;
		int x,y;
		//foreach(n; iota(0,total,unit)) {
		int t, count = unit / 2;
		loop1: foreach(a; 0 .. total) {
			x += 1;
			if (x > g_window.size.x) {
				y += 1;
				x = 0;
			}
			if (count == unit) {
				count = 0;
				thgs[t].destPos = Point(x, y);
				thgs[t].aim(_aimState);
				t += 1;
				if (t == thgs.length)
					break loop1;
			}
			count += 1;
		}
	}

    void clear() {
        thgs.length = 0;
    }

	void centre(Point pos) {
		void setPos(ref Thing t) {
			t.pos = pos;
			t.destPos = pos;
			t.dir = Point(0, 0);
		}
		thgs.each!((ref t) => setPos(t));
	}

	void setupOrder() {
		final switch(g_order) {
			case Phase.point:
				if (thgs.length < g_age)
					foreach(a; 0 .. g_age)
						thgs ~= Thing(0, _middlePos, _middlePos);
				else
					foreach(id, ref t; thgs) {
					 	t = Thing(cast(int)id + 1, thgs[id].pos, _middlePos);
						t.aim(_aimState);
					}
			break;
			case Phase.lineUp:
				int id = 1;
				auto pos = Point(g_sprite.getLocalBounds.width / 2, g_sprite.getLocalBounds.height / 2);
				if (thgs.length < g_age)
					foreach(a; 0 .. g_age)
						thgs ~= Thing(id, _middlePos, _middlePos);
				enum xstep = 40, ystep = 150;
				foreach(i; 0 .. g_age) {
					thgs[i] = Thing(id, thgs[i].pos, pos);
					thgs[i].aim(_aimState);
					pos.X += xstep;
					if (pos.X + g_sprite.getLocalBounds.width / 2 > g_window.size.x) {
						pos.X = g_sprite.getLocalBounds.width / 2;
						pos.Y += ystep;
					}
					id += 1;
				}
			break;
			case Phase.circle:
				int id = 1;
				if (thgs.length < g_age)
					foreach(a; 0 .. g_age)
						thgs ~= Thing(id, _middlePos, _middlePos);
				float maxDist = 0;
				size_t maxid;
				foreach(i; 0 .. g_age) {
					float num0 = i, ax, ay, dx, dy;
					immutable pibynum = ((PI * 2) / g_age) * num0;
					dx = _middlePos.X + sin(pibynum) * g_radiusw;
					dy = _middlePos.Y + cos(pibynum) * g_radiush;
					xyaim(&ax, &ay, getAngle(thgs[i].pos.X, thgs[i].pos.Y,
						dx,dy));
					
					// find the furtherest from homr
					// use the prevalues for th measure
					immutable t = distance(ax, ay, dx, dy);
					if (t > maxDist) {
						maxDist = t;
						maxid = i;
					}

					thgs[i] = Thing(id, Point(thgs[i].pos.X, thgs[i].pos.Y),
						Point(dx, dy),
						Point(ax, ay));
					//thgs[i] = Thing(id, thgs[i].pos, _middlePos + 
					//	Point(cast(float)sin(((PI * 2) / g_age) * num0) * g_radiusw,
					//		  cast(float)cos(((PI * 2) / g_age) * num0) * g_radiush),
					//		  Point(ax, ay));
					//debug
					//	writeln(thgs[i]);
					id += 1;
					//g_rotateCircle += 10;
				}
				version(none) {
					mixin(trace("maxid thgs[maxid].dir".split));
					foreach(const i, ref thg; thgs) {
						//thg.aim(_aimState, thgs[maxid].destPos);
						if (i == maxid)
							break;
						thg.dir = thg.dir / thgs[maxid].dir;
						//thg.dir.X /= thgs[maxid].dir.X;
						//thg.dir.Y /= thgs[maxid].dir.Y;
					}
				}
			break;
			//#Triangle
			case Phase.triangle:
			/+
				thgs.length = 0;
				immutable dist = 50f, third = g_age / 3;
				auto middlePos = Point(2560dd / 4, 1600 / 4);
				foreach(p; 0 .. third - 1)
					thgs ~= Thing(middlePos, middlePos - Point(0, third / 2 * dist) + Point(p * dist, p * dist)); // top to bottom right
				foreach(p; 0 .. third)
					thgs ~= Thing(middlePos, middlePos + Point(third / 2 * dist, third / 2 * dist) +
						Point(dist * third, dist * third) - Point(p * dist, 0)); // bottom left to bottom right
				foreach(p; 0 .. third - 1)
					thgs ~= Thing(middlePos, middlePos - Point(third / 2 * dist, third / 2 * dist) +
						Point(p * dist, p * dist)); // bottom left to top
						+/
			break;
			case Phase.square:
			/+
				immutable dist = 50f, side = g_age / 4;
				auto startPos = Point(2560 / 4, 1600 / 4) - Point(side * dist, side * dist);
				foreach(p; 0 .. side) {
					thgs ~= Thing(startPos, startPos + Point(p * dist, 0));
				}
				+/
			break;
		}
	}

	void process() {
		import std.parallelism : parallel;
		thgs.parallel.each!((ref t) => t.process);
	}

	void draw() {
		thgs.each!(t => t.draw);
		if (g_showNum)
			thgs.each!(t => t.draw(/* just num */ true));
	}
}
