#!/bin/sh

set -eu

output_dir="docs"
site_image="https://adriandusa.com/media.png"
image_width="1200"
image_height="630"

export SITE_IMAGE="$site_image"
export IMAGE_WIDTH="$image_width"
export IMAGE_HEIGHT="$image_height"

find "$output_dir" -name '*.html' -type f -print0 |
  while IFS= read -r -d '' file; do
    perl -0pi -e '
      my $site_image = $ENV{"SITE_IMAGE"};
      my $image_width = $ENV{"IMAGE_WIDTH"};
      my $image_height = $ENV{"IMAGE_HEIGHT"};

      s{<meta property="og:image" content="[^"]*">}{<meta property="og:image" content="$site_image">}g;
      s{<meta property="og:image:width" content="[^"]*">}{<meta property="og:image:width" content="$image_width">}g;
      s{<meta property="og:image:height" content="[^"]*">}{<meta property="og:image:height" content="$image_height">}g;
      s{<meta property="og:type" content="[^"]*">}{<meta property="og:type" content="website">}g;
      s{<meta name="twitter:image" content="[^"]*">}{<meta name="twitter:image" content="$site_image">}g;
      s{<meta name="twitter:image-width" content="[^"]*">}{<meta name="twitter:image-width" content="$image_width">}g;
      s{<meta name="twitter:image-height" content="[^"]*">}{<meta name="twitter:image-height" content="$image_height">}g;
      s{<meta name="twitter:card" content="[^"]*">}{<meta name="twitter:card" content="summary_large_image">}g;

      if ($_ !~ /<meta property="og:image"/) {
        s{</head>}{<meta property="og:image" content="$site_image">\n<meta property="og:image:width" content="$image_width">\n<meta property="og:image:height" content="$image_height">\n<meta property="og:type" content="website">\n</head>}s;
      }

      if ($_ !~ /<meta property="og:image:width"/) {
        s{(<meta property="og:image" content="\Q$site_image\E">\n)}{$1<meta property="og:image:width" content="$image_width">\n}s;
      }

      if ($_ !~ /<meta property="og:image:height"/) {
        s{(<meta property="og:image:width" content="\Q$image_width\E">\n)}{$1<meta property="og:image:height" content="$image_height">\n}s;
      }

      if ($_ !~ /<meta property="og:type"/) {
        s{(<meta property="og:image:height" content="\Q$image_height\E">\n)}{$1<meta property="og:type" content="website">\n}s;
      }

      if ($_ !~ /<meta name="twitter:image"/) {
        s{</head>}{<meta name="twitter:image" content="$site_image">\n<meta name="twitter:image-height" content="$image_height">\n<meta name="twitter:image-width" content="$image_width">\n<meta name="twitter:card" content="summary_large_image">\n</head>}s;
      }

      if ($_ !~ /<meta name="twitter:image-height"/) {
        s{(<meta name="twitter:image" content="\Q$site_image\E">\n)}{$1<meta name="twitter:image-height" content="$image_height">\n}s;
      }

      if ($_ !~ /<meta name="twitter:image-width"/) {
        s{(<meta name="twitter:image-height" content="\Q$image_height\E">\n)}{$1<meta name="twitter:image-width" content="$image_width">\n}s;
      }

      if ($_ !~ /<meta name="twitter:card"/) {
        s{(<meta name="twitter:image-width" content="\Q$image_width\E">\n)}{$1<meta name="twitter:card" content="summary_large_image">\n}s;
      }
    ' "$file"
  done
