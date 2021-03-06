class Kdiff3 < Formula
  desc "Compare and merge 2 or 3 files or directories"
  homepage "http://kdiff3.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.98/kdiff3-0.9.98.tar.gz"
  sha256 "802c1ababa02b403a5dca15955c01592997116a24909745016931537210fd668"

  bottle do
    cellar :any
    sha256 "33016974737b654b3b65f86c1485dfb377c23efa2c60efc08bbac48e40e333f6" => :el_capitan
    sha256 "50c90cad74a8393f859ae7f04b285c250361c49dddf88509f8292ebebc55c859" => :yosemite
    sha256 "8ddc33a57befb206127bcbe2a4ef4b4251830665945ba9170902231a63bddaf2" => :mavericks
  end

  depends_on "qt"

  def install
    # configure builds the binary
    system "./configure", "qt4"
    if OS.mac?
      prefix.install "releaseQt/kdiff3.app"
      bin.install_symlink prefix+"kdiff3.app/Contents/MacOS/kdiff3"
    else
      bin.install "releaseQt/kdiff3"
    end
  end

  test do
    (testpath/"test1.in").write "test"
    (testpath/"test2.in").write "test"
    system "#{bin}/kdiff3", "--auto", "test1.in", "test2.in", "-o", "test.out"
    assert (testpath/"test.out").exist?
  end
end
