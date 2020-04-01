{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
# Python dependencies
, setuptools_scm
, cython
, numpy
, plotly
, ply
, scipy
, deap
, notebook
, ipython
# Other/Optional Python dependencies
, cvxopt
, matplotlib
, mpi4py
, msgpack
, pandas
, psutil
, pyzmq
, jinja2
# Check Inputs
, coverage
# , pytestCheckHook
, nose
, rednose
, nose-timer
, python
}:

buildPythonPackage rec {
  pname = "pygsti";
  version = "0.9.9.1";

  # must download from GitHub to get the Cmake & C source files
  src = fetchFromGitHub {
    owner = "pyGSTio";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c028xfn3bcjfvy2wcnm1p6k986271ygn755zxw4w72y1br808zd";
  };

  disabled = isPy27;

  buildInputs = [
    cython
    setuptools_scm  # unused, but easier than patch
  ];

  propagatedBuildInputs = [
    numpy
    plotly
    ply
    scipy
  ];

  optionalPackages = [
    mpi4py
    deap
    pandas
    matplotlib
    jinja2
    ipython
    notebook
    msgpack
  ];

  postPatch = ''
    export SRC_DIR=$(pwd)
    substituteInPlace setup.py --replace "use_scm_version=custom_version" "version='${version}'"
  '';

  extraCheckInputs = [
    coverage
    cvxopt
    # cvxpy
    cython
    matplotlib
    mpi4py
    msgpack
    pandas
    psutil
    pyzmq
    jinja2
  ];

  pythonImportsCheck = [
    "pygsti"
    "pygsti.algorithms"
    "pygsti.drivers"
    "pygsti.extras"
    "pygsti.io"
    "pygsti.modelpacks"
    "pygsti.objects"
    "pygsti.optimize"
    "pygsti.protocols"
    "pygsti.report"
    "pygsti.tools"
  ];

  checkInputs = [ nose nose-timer rednose ];
  dontUseSetuptoolsCheck = true;
  # pytestFlagsArray = [
  #   "--rootdir=$SRC_DIR/test/unit"
  # ];
  preCheck = ''
    ls $SRC_DIR/test/unit
  '';
  checkPhase = ''
    runHook preCheck

    nosetests test/unit

    runHook postCheck
  '';

  meta = with lib; {
    description = "TODO";
    homepage = "";
    downloadPage = "";
    license = licenses.asl20;
    # maintainers = with maintainers; [ drewrisinger ];
  };
}
