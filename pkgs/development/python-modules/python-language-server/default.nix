{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder, isPy27
, backports_functools_lru_cache, configparser, futures, future, jedi, pluggy, python-jsonrpc-server, flake8
, pytest, mock, pytestcov, coverage, setuptools
, numpy, pandas, matplotlib, pyqt5
, # Allow building a limited set of providers, e.g. ["pycodestyle"].
  providers ? ["*"]
  # The following packages are optional and
  # can be overwritten with null as your liking.
, autopep8 ? null
, mccabe ? null
, pycodestyle ? null
, pydocstyle ? null
, pyflakes ? null
, pylint ? null
, rope ? null
, yapf ? null
}:

let
  withProvider = p: builtins.elem "*" providers || builtins.elem p providers;
in

buildPythonPackage rec {
  pname = "python-language-server";
  version = "0.31.8";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-language-server";
    rev = version;
    sha256 = "1h0w7x7d9g3z7vmxn5w7qxdkjya3sl0xfnklfaaaj8dkb5mjldpi";
  };

  # The tests require all the providers, disable otherwise.
  doCheck = providers == ["*"];

  checkInputs = [
    pytest mock pytestcov coverage flake8 numpy pandas matplotlib pyqt5
    # rope is technically a dependency, but we don't add it by default since we
    # already have jedi, which is the preferred option
    rope
  ];

  checkPhase = ''
    flake8 --help
    HOME=$TEMPDIR pytest
  '';

  propagatedBuildInputs = [ setuptools jedi pluggy future python-jsonrpc-server flake8 ]
    ++ stdenv.lib.optional (withProvider "autopep8") autopep8
    ++ stdenv.lib.optional (withProvider "mccabe") mccabe
    ++ stdenv.lib.optional (withProvider "pycodestyle") pycodestyle
    ++ stdenv.lib.optional (withProvider "pydocstyle") pydocstyle
    ++ stdenv.lib.optional (withProvider "pyflakes") pyflakes
    ++ stdenv.lib.optional (withProvider "pylint") pylint
    ++ stdenv.lib.optional (withProvider "rope") rope
    ++ stdenv.lib.optional (withProvider "yapf") yapf
    ++ stdenv.lib.optional isPy27 configparser
    ++ stdenv.lib.optionals (pythonOlder "3.2") [ backports_functools_lru_cache futures ];

  meta = with stdenv.lib; {
    homepage = https://github.com/palantir/python-language-server;
    description = "An implementation of the Language Server Protocol for Python";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
