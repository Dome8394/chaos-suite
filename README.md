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

# Using Environment Variables

Currently the environment variables are not working due to some unknown issue (probably based on the CTK).
Hence, this functionality is postponed.  

# Experiment description

Currently, there are three experiments with respect to a Kubernetes cluster.

- basic-healthcheck-sl.json
- basic-pod-termination-norand.json
- basic-pod-termination-randomperc.json

Note, that these experiments currently contain secrets that are required to access the target application. However, other than that, the residual content of the experiments is quite generic and may be applied to any other Kubernetes cluster. You may, however, change the label selectors if you wish to run experiments on specific pods. 

## Steady-State hypothesis

The steady-state hypothesis is based on a simple *cURL* request that expects an HTTP status code *200* in order to be flagged as successful.

The request is specified as follows.

    "steady-state-hypothesis": {
            "title": "Healthcheck",
            "probes": [
                {
                    "type": "probe",
                    "name": "application-must-respond",
                    "tolerance": 200,
                    "provider": {
                        "secrets": [
                            "login"
                        ],
                        "type": "http",
                        "url": "http://dev-dke.kundenplattform.plattform.cloud/space/#/start",
                        "headers": {
                            "Authorization": "${bearer}"
                        }
                    }
                }
            ]
        }

A steady-state hypothesis contains a number of probes that query the state of the system. No system changes will be injected in this phase. 

Currently, the steady-state hypothesis contains only one probe that will query the landing page of the customer platform. As in a basic *cURL* issued from the shell, the http probe provided by CTK can be customized if required, i.e., setting http headers and such. 

In this case, accessing the landing page requires a login with a *username* and *password*. These are set specifically in a secrets block outside of the steady-state hypothesis but may be passed to the probe in the *provider* section. A secret block may look like the following.

    "secrets": {
        "login": {
            "username": "Admin",
            "password": "Start123"
        },
        "bearer": {
            "token": "Bearer ...
        }
    }

## Generic Methods

In the following, I will demonstrate the generic approaches to test a Kubernetes cluster. Consider, that more complex experiments are possible. I will observe potential changes in the cluster by using 

        $ kubectl watch get all

Note, that good chaos engineering requires proper monitoring solutions in order to get better results.

### Non-randomized approaches

Randomized chaos engineering is practices since this method has been published by Netflix. However, current research aims to demonstrate that combining randomized with non-randomized approaches yields better results in terms of efficiency and found weaknesses. 

A basic termination of a Kubernetes pod looks like the following.

    "method": [
        {
            "type": "action",
            "name": "kill-microservice",
            "provider": {
                "module": "chaosk8s.pod.actions",
                "type": "python",
                "arguments": {
                    "label_selector": "app=",
                    "mode": "fixed",
                    "qty": 1,
                    "ns": "default"
                },
                "func": "terminate_pods"
            }
        }
    ]

Inside a method block, actions may be defined to *change the system state*, i.e., injecting failures. The *chaostoolkit-kubernetes* extension provides a set of experiments that may be used to run chaos experiments (see [official documentation](https://docs.chaostoolkit.org/drivers/kubernetes/)).

The respective Kubernetes CTK provider uses the module "chaosk8s.pod.actions" for pod actions, e.g., termination. Inside the provider, you can pass different arguments to select Kubernetes pods.  

    "arguments": {
                    "label_selector": "app=<label-of-application>",
                    "mode": "fixed",
                    "qty": 1,
                    "ns": "default"
                }

In this case, I used four different arguments. 

1. label_selector – Determines a specific pod by its label
2. mode – distinguishes the mode on how to select pods. Can either be "fixed" or "percentage"
3. qty – Quantity of pods to select. By default set to "1"
4. ns – Determines the namespace where the pods are assigned to

Based on the above explanation, this experiments will select a specific pod based on the label_selector and gracefully terminates it. By default, the pod_termination provided by CTK, terminates a pod gracefully, i.e., a currently running process inside the pod is allowed to finish before the pod is terminated. Other options to terminate pods include:

- rand – If set to TRUE, "n" random pods will be terminated
- all – Terminates all retrieved pods
- mode="percentage" – Terminates a given percentage of pods in range of 1 to 100 specified by "qty"
- grace_period – Determines a grace period before a pod is terminated
- order – Provides a order on how to terminate retrieved pods

### Randomized Approaches

In the following, I will demonstrate an experiment to terminate a number of Kubernetes pods based on a percentage range.

            {
                "type": "action",
                "name": "kill-microservice",
                "provider": {
                    "module": "chaosk8s.pod.actions",
                    "type": "python",
                    "arguments": {
                        "label_selector": "app=<label-of-application>",
                        "mode": "percentage",
                        "qty": 25,
                        "ns": "default"
                    },
                    "func": "terminate_pods"
                }
            }

The above provider shows a different *mode* property. *Mode* is set to "percentage". This requires the *qty* property to be a value between 0 and 100. In this case, *qty* is set to 25, i.e., 25% of the retrieved Kubernetes pods will be terminated. Note, that I also specified a label_selector. This comes in handy if 
