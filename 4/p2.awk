#!/usr/bin/awk -f

function dim_to_offset(x, y) {
  return (y * width) + x + 1
}

function is_xmas(x, y, d) {

  if(x + 1 >= width || x - 1 < 0)
    return 0

  if(y + 1 >= height || y - 1 < 0)
    return 0

  p1 = dim_to_offset(x + 1, y + d)
  p2 = dim_to_offset(x - 1, y - d)
  result = substr(buffer, p1, 1) \
    substr(buffer, p2, 1)

  return (result == "MS" || result == "SM")
}

BEGIN {
  height = 1
  size = 0
  ret = 0

  if((getline line < "input") <= 0)
    exit 1

  buffer = line
  width = length(line)
  while ((getline line < "input") > 0) {
    height++
    buffer = buffer line
  }

  size = height * width
  for(i = 0; i < size; i++) {
    if(substr(buffer, i + 1, 1) != "A")
      continue;

    x = i % width
    y = int(i / width)
    if(is_xmas(x, y, -1) && is_xmas(x, y, 1))
      ret++
  }

  print(ret) # 1969
}