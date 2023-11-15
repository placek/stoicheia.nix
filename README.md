# stoicheia.nix

The simplest, modular framework to define Nix configuration for any project.

## Why?

Firstly, **there are many ways to prepare a Nix configuration for a project.**

In fact there are too many ways to do that! There is no such thing as a standard
configuration pattern/strategy/structure… the developer implementing the
configuration is the only person responsible for decisions they made during
designing it.

Anyone joining a project supported by Nix configuration is forced to learn a new
way of organizing and structuring the configuration. And of course it changes
between projects. There are many ways of:

* pinning packages,
* passing arguments,
* sharing common values,
* organizing expressions in dir/file structure,
* defining dependencies,
* etc.

`stoicheia.nix` is here to simplify the Nix configuration, flatten it, make it
modular, document it… It introduces a unified convention and leaves just enough
flexibility.

Secondly, **Nix expressions are hard to read when not put in a straightforward
structure.**

When there is some complexity involved then it is expected to leave a comment
on the piece of Nix code. It is always hard to maintain such comment-driven
documentation.

Some expressions are introduced into a configuration only because of specifics
of Nix language itself. Evaluation of Nix expressions are strict and verified
at execution time only. This means that in any project's configuration there
will be strange helpers, or structures put there just to fulfill the Nix
expression needs. Existance of such "helpers" normaly obfuscates the whole view
and makes it hard to understand. Commenting such code not always helps…

`stoicheia.nix` is here to move necessary complexity outside of configuration
and leave just clear structure of the configuration and it's documentation.

Thirdly, **Nix configuration drifts towards more and more nesting.**

When evaluating the configuration developer expects to find the parts they are
insterested in quickly and straightforward. Unfortunately, oftenly this is not
the case. The configuration attached to typical project is deep. This
introduces additional complexity and makes the configuration less and less
readable.

To address that issue `stoicheia.nix` uses NixOS modules to flatten the
configuration as mauch as it could. The idea is to keep up to 3 levels of
nesting, to make it readable on evaluation.

On the other hand, **Nix configuration typically has no clear values shareing
mechanism.**

There are many approaches to utilize shared values in Nix expressions. Some
of them involve a settings attribute set, others inject the global configuration
by passing them as an argument to functons, some of them are setting global
values at the highest level of configuration, etc. There is no unified approach
to it.

`stoicheia.nix` uses NixOS modules, and all options defined in any module are
available for any other modue as well. It makes the configuration clear,
readable and still composable with all the parameters known at any place.
The only limitation here is possibility of infinite loop occurrence.

Additionaly, **the behaviour of typical Nix configuration does not raise human
readable errors in case of failures.**

Any piece of `stoicheia.nix` configuration is an option - apart form name and
value it has also a type and can be provided with documentation and/or
example. It enhance the evaluation failures with adequate messages.

This is typically not the case when using standard Nix expressions. The error
messages are context-related and provided rather in an evaluation backtrace
style than a validation messaging.

## How?

See [example](./example).

The `stoicheia.nix` mimics the home-manager configuration technique. It
evaluates a builitin module that defines several options and composes it with
the configuration module defined by user.

Simplest usage is to define the configuration module, as follows:

```nix
let
  stoicheia = import (builtins.fetchGit { url = "https://github.com/placek/stoicheia.nix.git"; }) {
    pkgs = import <nixpkgs> {};
  };
in
stoicheia.mkProject {
  config = {
    name = "my-project";
    version = "0.1.0";
    …
  };
}
```

The `config` attribute is a NixOS module. It can be an attribute set or the
function:

```nix
let
  stoicheia = import (builtins.fetchGit { url = "https://github.com/placek/stoicheia.nix.git"; }) {
    pkgs = import <nixpkgs> {};
  };
in
stoicheia.mkProject ({ pkgs.lib, pkgs, ... }: {
  name = "my-project";
  version = lib.versions.pad 2 "0.1.0";
  packages.ruby = pkgs.ruby;
})
```

The `stoicheia.nix` argument can define include `modules`:

```nix
let
  stoicheia = import (builtins.fetchGit { url = "https://github.com/placek/stoicheia.nix.git"; }) {
    pkgs = import <nixpkgs> {};
  };
in
stoicheia.mkProject ({ pkgs.lib, pkgs, ... }: {
  imports = [
    ./shell.nix
    ./modules/some-other-configuration
  ];

  conifg = {
    name = "my-project";
    version = lib.versions.pad 2 "0.1.0";
    packages.ruby = pkgs.ruby;
  };
})
```
