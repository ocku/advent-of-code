#!/usr/bin/awk -f

function dim_to_offset(x, y) {
  return (y * width) + x;
}

function is_within_bounds(x, y) {
  return x > 0 && x <= width && \
    y > 0 && y < height
}

function is_obstacle(x, y) {
  offset = dim_to_offset(x, y);
  return substr(buffer, offset, 1) == "#";
}

function set_px(offset, px) {
  return substr(buffer, 1, offset - 1) px \
    substr(buffer, offset + 1);
}

function get_px(offset) {
  return substr(buffer, offset, 1);
}

function turn() {
  if(guard["dy"] == -1) {
    guard["dx"] = 1;
    guard["dy"] = 0;
  } else if(guard["dx"] == 1) {
    guard["dx"] = 0;
    guard["dy"] = 1;
  } else if(guard["dy"] == 1) {
    guard["dx"] = -1;
    guard["dy"] = 0;
  } else if(guard["dx"] == -1) {
    guard["dx"] = 0;
    guard["dy"] = -1;
  }
}

function walk() {

  guard["dx"] = 0;
  guard["dy"] = -1;
  offset = index(buffer, "^");
  guard["x"] = offset % width;
  guard["y"] = int(offset / width) - 1;

  while(is_within_bounds(guard["x"], guard["y"])) {

    key = dim_to_offset(guard["x"], guard["y"])
    if(++visited[key] > 3) return 1

    is_obstacle( \
      guard["x"] + guard["dx"], \
      guard["y"] + guard["dy"]  \
    ) && turn();

    guard["x"] += guard["dx"];
    guard["y"] += guard["dy"];
  }

  return 0
}

BEGIN {
  while ((getline line < "input") > 0) {
    height++;
    buffer = buffer line;
  }

  width = length(line);

  walk()
  for(position in visited)
    path[position] = 1;

  loops = 0;
  for(position in path) {

    split("", visited);
    if(get_px(position) != ".")
      continue

    buffer = set_px(position, "#");
    loops += walk();
    buffer = set_px(position, ".");
  }

  print(loops); # 1431
}