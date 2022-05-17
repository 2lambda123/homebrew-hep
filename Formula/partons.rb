class Partons < Formula
  desc "PARtonic Tomography Of Nucleon Software"
  homepage "http://partons.cea.fr"
  url "https://drf-gitlab.cea.fr/partons/core/partons/-/archive/v3.0/partons-v3.0.tar.gz"
  sha256 "03a5c6382e74d89f479a85fdcc3246403b6a5c3663a04710fb39321c2002da83"
  license all_of: ["Apache-2.0", "GPL-3.0-only"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, monterey: "c69313af8761ae49dd4901ae07aed36dccb5a9528f40ba6a6e07250de1b1ddc6"
    sha256 cellar: :any, big_sur:  "efcdd9b5f8f6929fb2fddb542f10367b61646bb8419dddde526bb9d297558eb7"
    sha256 cellar: :any, catalina: "b1242e3172cd92af37b78a7ba709c3b6fe8e5c961dc008f11af8eeb6ce4abb21"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "apfelxx"
  depends_on "cln"
  depends_on "eigen"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "lhapdf"
  depends_on "qt@5"
  depends_on "sfml"

  resource "elementary-utils" do
    url "https://drf-gitlab.cea.fr/partons/core/elementary-utils/-/archive/v3.0/elementary-utils-v3.0.tar.gz"
    sha256 "cddddf26b7d0104530e75a34ed46ec0bbabd881f17ea51f0efe01265c923e812"
  end

  resource "numa" do
    url "https://drf-gitlab.cea.fr/partons/core/numa/-/archive/v3.0/numa-v3.0.tar.gz"
    sha256 "d7c15d25d092d72be55346d8c3192dc81b08ebd93b3e62b37fc809cd598d96e9"
  end

  resource "partons-test" do
    url "https://drf-gitlab.cea.fr/partons/core/partons-example/-/archive/v3.0/partons-example-v3.0.tar.gz"
    sha256 "f4f7feb64c0afd53f054cedd6c5ca91e0267c4d423986e54ce3d1e8a6cb329c6"
  end

  def install
    resource("elementary-utils").stage do
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make", "install"
    end

    resource("numa").stage do
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make", "install"
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("partons-test")
    system "cmake", ".", *std_cmake_args, "-DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_prefix}"
    system "make"
    system testpath/"bin/PARTONS_example", "data/examples/gpd/computeSingleKinematicsForGPD.xml"
  end
end
