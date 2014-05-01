# Useful functions for graphics artists.
#
# by torstein.k.johansen@conduct.no

## dependencies
which identify &>/dev/null || {
  echo $(basename $0) "requires imagemagick to be installed"
  exit 1
}

## $1 :: the image file
function get_image_width_and_height() {
  if [ ! -r $1 ]; then
    return
  fi

  identify "$1" | cut -d' ' -f3
}

## $1 :: the image file
function get_image_width() {
  IFS=x read width height <<< $(get_image_width_and_height "$1")
  echo $width
}

## $1 :: the image file
function get_image_height() {
  IFS=x read width height <<< $(get_image_width_and_height "$1")
  echo $height
}

## test
# echo $(get_image_width $HOME/src/studio-s.no/orig/i-22278--24_copy.jpg)
# echo $(get_image_height $HOME/src/studio-s.no/orig/i-22278--24_copy.jpg)
# echo $(get_image_width_and_height $HOME/src/studio-s.no/orig/i-22278--24_copy.jpg)
