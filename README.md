# Experiment CLI Commands

In the following, we will provide a detailed overview of how to run the chaos experiments in Chaos Toolkit (CTK).

# Requirements to run Chaos Experiments in CTK

* [CTK has to be installed](https://docs.chaostoolkit.org/)
* CTK requires [Python](https://www.python.org/downloads/) to be installed in order to work. Any version above 3.x will do.
* Python package installer [pip](https://pypi.org/project/pip/)

# How to install CTK

For detailed instructions please visit the official [Chaos Toolkit documentation](https://docs.chaostoolkit.org/).
We have used [brew](https://brew.sh/index_de) to install python and CTK. The following commands may be used to install python
on your machine. 

**On MacOS X:**

    $ brew install python3

**On Debian/Ubuntu:**

    $ sudo apt-get install python3 python3-venv

**On Windows:**

[Download the latest binary installer](https://www.python.org/downloads/windows/) from the Python website.

## Virtual Environment

It is recommended to create a virtual environment for package management in order to keep your machine clean and avoid package conflicts. 
Remember to always activate your virtual environment before you install or use the CTK. However, it is a recommendation only! A virtual environment is not required by the CTK in order to be used.

You can create a virtual environment by using the following commands:

    $ python3 -m venv ~/.venvs/chaostk

The virtual environment is not required to be placed in the home directory. You can choose whatever directory you want.

The environment can be activated by using:

    $ source ~/.venvs/chaostk/bin/activate

The command to activate the virtual environment may deviate depending on your shell and operating system.

After the environment has been installed and activated you are ready to install the chaos CLI:

    $ (chaostk) $ pip install chaostoolkit

# Installing Extensions

Please have a lookt at the official [Drivers Reference](https://docs.chaostoolkit.org/drivers/cloudfoundry/) provided by ChaosIQ in order to install any extension. In general you can use the following command to install an extension:

    $ pip install -U <name-of-the-extension>

Other useful libraries which you might need:

    $ pip install jsonpath2

# Running Experiments

In order to run and manage your experiments you can use the following CLI commands:

    $ chaos run experiment-test.json

In general, it is useful to run 

    $ chaos --help

in order to get familiar with the CLI. The above command will serve

    Usage: chaos [OPTIONS] COMMAND [ARGS]...

    Options:
    --version           Show the version and exit.
    --verbose           Display debug level traces.
    --no-version-check  Do not search for an updated version of the
                        chaostoolkit.
    --change-dir TEXT   Change directory before running experiment.
    --no-log-file       Disable logging to file entirely.
    --log-file TEXT     File path where to write the command's log.  [default:
                        chaostoolkit.log]
    --settings TEXT     Path to the settings file.  [default:
                        /Users/dominik/.chaostoolkit/settings.yaml]
    --help              Show this message and exit.

    Commands:
    discover  Discover capabilities and experiments.
    info      Display information about the Chaos Toolkit environment.
    init      Initialize a new experiment from discovered capabilities.
    report    Generate a report from the run journal(s).
    run       Run the experiment loaded from SOURCE, either a local file or a...
    validate  Validate the experiment at PATH.

## Using Environment Variables

-- TODO

### Troubleshooting