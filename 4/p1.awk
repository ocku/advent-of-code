#!/usr/bin/awk -f

function dim_to_offset(x, y) {
  return (y * width) + x + 1
}

function is_xmas(x, y, dx, dy) {

  edgeX = x + dx * 3
  if(edgeX < 0 || edgeX > width)
    return 0

  edgeY = y + dy * 3
  if(edgeY < 0 || edgeY > height)
    return 0

  pm = dim_to_offset(x + dx, y + dy);
  pa = dim_to_offset(x + (2 * dx), y + (2 * dy));
  ps = dim_to_offset(x + (3 * dx), y + (3 * dy));
  result = substr(buffer, pm, 1) \
    substr(buffer, pa, 1) \
    substr(buffer, ps, 1)

  return result == "MAS"
}

BEGIN {
  buffer = ""
  height = 1
  size = 0
  ret = 0

  if((getline line < "input") <= 0)
    exit 1

  buffer = buffer line
  width = length(line)
  while ((getline line < "input") > 0) {
    height++
    buffer = buffer line
  }

  size = height * width
  for(i = 0; i < size; i++) {
    if(substr(buffer, i + 1, 1) != "X")
      continue

    x = i % width
    y = int(i / width)
    is_xmas(x, y, 0, 1) && ret++
    is_xmas(x, y, 1, 1) && ret++
    is_xmas(x, y, 1, 0) && ret++
    is_xmas(x, y, 1, -1) && ret++
    is_xmas(x, y, 0, -1) && ret++
    is_xmas(x, y, -1, -1) && ret++
    is_xmas(x, y, -1, 0) && ret++
    is_xmas(x, y, -1, 1) && ret++
  }

  print(ret) # 2507
}