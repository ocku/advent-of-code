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
  guard["y"] = int(offset / width) + 1;

  while(is_within_bounds(guard["x"], guard["y"])) {
    visited[guard["x"] "-" guard["y"]]++

    is_obstacle( \
      guard["x"] + guard["dx"], \
      guard["y"] + guard["dy"]  \
    ) && turn();
    
    guard["x"] += guard["dx"];
    guard["y"] += guard["dy"];
  }

  return length(visited)
}

BEGIN {
  while ((getline line < "input") > 0) {
    height++;
    buffer = buffer line;
  }

  width = length(line);
  size = height * width;

  print(walk()); # 4939
}