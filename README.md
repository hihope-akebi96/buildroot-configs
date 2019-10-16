# Akebi96 buildroot configs

## What is this?

This is a repository of buildroot configurations for Akebi96 board.
Akebi96 board consists of UniPhier LD20 SoC and some on-board chips.
These configurations work as additional configurations of buildroot
for Akebi96 board, which include kernel configurations, devicetree
fragments, patches, and makefiles for building additional packages.

## How can I use this?

You can specify these configs, and make buildroot.

```
 $ AKEBI96=<this repository>
 $ cd buildroot
 $ make BR2_EXTERNAL=${AKEBI96} akebi96_defconfig
 $ make clean
 $ make
```

## License

Everything in this repository is distributed under MIT License.
See https://opensource.org/licenses/MIT for details.

Copyright 2019 Socionext Inc.
