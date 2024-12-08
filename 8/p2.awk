#!/usr/bin/awk -f

function dim_to_offset(x, y) {
  return (y - 1) * width + (x - 1);
}

function is_within_bounds(x, y) {
  return x >= 1 && x <= width && \
    y >= 1 && y <= height
}

BEGIN {
  while ((getline line < "input") > 0) {
    height++;
    buffer = buffer line;
  }

  width = length(line);
  size = length(buffer);

  for (i = 1; i <= size; i++) {
    char = substr(buffer, i, 1);
    if (char == ".")
      continue;

    x1 = (i - 1) % width + 1;
    y1 = int((i - 1) / width) + 1;

    for (j = 1; j <= size; j++) {
      char2 = substr(buffer, j, 1);
      if (i == j || char != char2)
        continue;

      x2 = (j - 1) % width + 1;
      y2 = int((j - 1) / width) + 1;

      dx = x2 - x1;
      dy = y2 - y1;

      while (is_within_bounds(x2, y2)) {
        antinodes[x2 " - " y2] = 1;
        x2 += dx;
        y2 += dy;
      }
    }
  }

  print length(antinodes);
}