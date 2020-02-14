{ stdenv, buildPythonPackage, fetchPypi, pytest, glibcLocales, tox, pytestcov, parso }:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mb5kmrk9bkc3kwzx02j62cdan1jqd92q1z7h7wi9d30jg5p3j6m";
  };

  # postPatch = ''
  #   substituteInPlace requirements.txt --replace "parso==0.1.0" "parso"
  # '';

  checkInputs = [ pytest glibcLocales tox pytestcov ];

  propagatedBuildInputs = [ parso ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test test
  '';

  # tox required for tests: https://github.com/davidhalter/jedi/issues/808
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/davidhalter/jedi;
    description = "An autocompletion tool for Python that can be used for text editors";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
