# Running Rhino3D on Linux
*A practical guide for running Rhino3D through Wine*

![A whimsical rhino enjoying wine](media/rhino-wine.png)

## Why This Guide Exists
The landscape of professional computing is changing. With growing concerns about operating system privacy, forced updates, and user autonomy, many designers and architects are looking to Linux. Rhino - a critical tool for many of us - has historically been a blocker for this transition. This guide provides tested, working solutions for running Rhino on Linux systems.

## What Works
Through careful testing and refinement of Wine configurations, I've developed reliable methods to run Rhino (particularly version 7) on Linux. While not officially supported by McNeel, these methods are working for real production use in studios and workshops worldwide.

## What To Expect
This isn't a perfect 1:1 replacement for running Rhino on Windows. You'll encounter:
- Some UI quirks that need specific workarounds
- Slightly longer startup times
- Occasional viewport refresh issues
- Limited GPU rendering support

However, core functionality - including Grasshopper - works reliably once properly configured.

## Before You Begin
- These guides assume basic familiarity with Linux command line operations
- You'll need to be comfortable following technical instructions precisely
- Having a backup workflow (like a Windows VM) during transition is recommended
- Different distros require slightly different approaches - follow the guide specific to yours

## A Note About Support
While McNeel has been supportive of users running Rhino on Wine, this is not an officially supported configuration. The solutions presented here come from extensive testing and refinement. When you encounter issues, please open an issue in this repository.

## Contributing
This is an open project and contributions are welcome. If you find improvements or solutions for different distributions, please consider submitting a pull request.

## Installation Guides
- [Debian-based Installation](guides/rhino-debian.md)
- [Arch Linux Installation](guides/rhino-arch.md)
- [Automated Setup Scripts](guides/setup-scripts.md) - For automated installation using our tested scripts

## Directory Structure
```
rhino-wine/
├── README.md (this file)
├── guides/
│   ├── rhino-debian.md
│   ├── rhino-arch.md
│   ├── setup-scripts.md
│   └── media/
├── media/
│   └── rhino-wine.png
└── scripts/
    ├── setup-rhino7-arch.sh
    └── setup-rhino7-debian.sh
```

## Tested Configurations
Currently tested and working combinations:

| Distro | Wine Version | Rhino Version | Status |
|--------|--------------|---------------|---------|
| Ubuntu 22.04 | 9.20 | Rhino 7 | ✅ Working |
| Arch Linux 6.12.1-arch1-1 | 9.20 | Rhino 7 | ✅ Working |

## License
GNU GENERAL PUBLIC LICENSE (see in repo)
