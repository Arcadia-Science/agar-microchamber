# Agar Microchamber Image Processing and Analysis

This repository contains code for processing images of diverse motile organisms, as well as code for analyzing confinement space for a range of organisms of different sizes. The processed images and analysis are included in the publication ['Gotta catch ‘em all: agar microchambers for high-throughput single cell live imaging'](https://doi.org/10.57844/arcadia-v1bg-6b60). Also, a detailed protocol for making the agar microchambers can be found on protocols.io. [Molding microchambers in agar with PDMS stamps for live imaging](https://dx.doi.org/10.17504/protocols.io.j8nlkwpk1l5r/v1).

[![DOI](https://zenodo.org/badge/625005856.svg)](https://zenodo.org/badge/latestdoi/625005856)


Summary of _Chlamydomonas smithii_ motility in agar microchamber

![cs_var_sum_8bit](https://user-images.githubusercontent.com/110641190/231519235-1e491dec-f6c9-4967-aeda-124b9416d838.png)

## How to run

This repository has two independent parts:

- **R analysis notebook** (`code/R/analysis.ipynb`) predicts optimal chamber sizes from the publicly available [BOSO-Micro dataset](https://doi.org/10.1371/journal.pone.0252291), which it downloads itself. It is intended to run on Google Colab and uses Unix shell commands (`wget`/`unzip`), so a Unix-like environment is required (the Windows workstation specs below describe the Fiji image-processing setup, not the R notebook). Open it directly in Colab:
  [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Arcadia-Science/agar-microchamber/blob/main/code/R/analysis.ipynb)
- **Fiji macros** (`code/Fiji/*.ijm`) are interactive image-processing utilities run from [Fiji](https://imagej.net/software/fiji/) (ImageJ2 2.9.0/1.53t). See `code/Fiji/README.md` for what each macro does. The microscopy images these macros operate on are published with the associated [pub](https://doi.org/10.57844/arcadia-v1bg-6b60).

## Versions and platforms

_Fiji macro_ was used with ImageJ2 Version: 2.9.0/1.53t Build: a33148d777

Computation was performed on an image analysis workstation with the following specifications.

Operating system: Windows 10 Pro Version 21H2 OS Build 19044.1889

Platform | Intel Xeon C621E EATX
Motherboard | Supermicro X12SPA-TF 64L
CPU | Intel Xeon W-3365 2.7GHz Thirty-Two Core 48MB 270W |
RAM | 8 x DDR4-3200 64GB ECC Reg.
Video Card | NVIDIA RTX A6000 48GB PCI-E
Primary Hard Drive | Samsung 980 Pro 2TB Gen4 M.2 SSD |
Secondary Hard Drive | Samsung 870 EVO 4TB SATA3 2.5inch SSD |
Tertiary Hard Drive | Western Digital Ultrastar 18TB SATA3 |
Case | Fractal Design Define 7 XL
Power Supply | Super Flower LEADEX Platinum 850W |
Additional Cooling | Case Fans Upgrade Kit (PWM Ramping) |

## Contributing

See how we recognize [feedback and contributions on our code](https://github.com/Arcadia-Science/arcadia-software-handbook/blob/main/guides-and-standards/guide-credit-for-contributions.md).
