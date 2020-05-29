# Experiment CLI Commands

In the following, we will provide a detailed overview of how to run and execute the chaos experiments.

# Requirements

* Chaos Toolkit (CTK) has to be installed
* CTK requires Python 3 to be installed in order to work

Our Setup:

* CTK version 1.4.1
* Python 3.x
* pip version 20.1

# How to install CTK

For detailed instructions please visit the official [Chaos Toolkit documentation](https://docs.chaostoolkit.org/).

In order to install the CTK, you need to install Python. If you have already Python installed in your environment you can skip this step.

On MacOS X:

$ brew install python3

On Debian/Ubuntu:

$ sudo apt-get install python3 python3-venv

On Windows:

[Download the latest binary installer](https://www.python.org/downloads/windows/) from the Python website.

## Virtual Environment

It is recommended to create a virtual environment for package management. You can create a virtual environment by using the following commands:

$ python3 -m venv ~/.venvs/chaostk

The environment can be activated by using:

$ source ~/.venvs/chaostk/bin/activate

After the environment has been installed you are ready to install the chaos CLI

$ (chaostk) $ pip install chaostoolkit

# Installing Extensions

Please have a lookt at the official [Drivers Reference](https://docs.chaostoolkit.org/drivers/cloudfoundry/) provided by ChaosIQ in order to install any extension. In general you can use the following command to install an extension:

$ pip install -U <name-of-the-extension>

In this project, we will use the following extension:

$ pip install -U chaostoolkit-cloud-foundry

You will, most likely, need the following python library as well:

$ pip install jsonpath2

# Running Experiments

In order to run and manage your experiments you can use the following CLI commands:

$ chaos run experiment-test.json

## Using Environment Variables

-- TODO

### Troubleshooting