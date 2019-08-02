{ lib
, python3Packages
, fetchFromGitHub
}:

let 
  pyqtgraph-pyqt5 = python3Packages.buildPythonPackage rec {
    pname = "pyqtgraph";
    version = "0.10.0";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "4c08ab34881fae5ecf9ddfe6c1220b9e41e6d3eb1579a7d8ef501abb8e509251";
    };

    propagatedBuildInputs = with python3Packages; [ scipy numpy pyqt5 pyopengl ];

    doCheck = false;  # "PyQtGraph requires either PyQt4 or PySide; neither package could be imported."
  };

in
  python3Packages.buildPythonApplication rec {
    pname = "cq-editor";
    version = "0.1RC1";

    src = fetchFromGitHub {
      owner = "CadQuery";
      repo = "CQ-editor";
      rev = version;
      sha256 = "0iwcpnj15s64k16948sakvkn1lb4mqwrhmbxk3r03bczs0z33zax";
    };

    propagatedBuildInputs = with python3Packages; [
      cadquery
      Logbook
      pyqt5
      # pyside2
      pyparsing
      pyqtgraph-pyqt5
      spyder
      pathpy
      requests
    ];

    checkInputs = with python3Packages; [
      pytest
      pytest-xvfb
      pytest-mock
      pytestcov
      pytest-repeat
      pytest-qt
    ];

    checkPhase = ''
      pytest --no-xvfb
    '';

    # requires X server
    doCheck = false;

    meta = with lib; {
      description = "CadQuery GUI editor based on PyQT";
      homepage = https://github.com/CadQuery/CQ-editor;
      license = licenses.asl20;
      maintainers = [ maintainers.costrouc ];
    };

  }
