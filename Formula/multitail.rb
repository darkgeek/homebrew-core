class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://vanheusden.com/multitail/multitail-6.4.2.tgz"
  sha256 "af1d5458a78ad3b747c5eeb135b19bdca281ce414cefdc6ea0cff6d913caa1fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "967b77c466bb79a341ecbca261d4f263859d008e25746405f3444cb7de482ad4" => :sierra
    sha256 "01ac7f53386a8099b4dd9e80bcc14dcb8097676199819ed8e2dc2a0893aba930" => :el_capitan
    sha256 "60c748bbcac5188c00b1f0033bb46491623061cf08dfc5e6f5514d9b6042b5f4" => :yosemite
    sha256 "5d2219191236e2209bb4642ecb865716390e9984b27ce145f391fb2280e9f906" => :mavericks
    sha256 "1f91b4097931555c64e2e9bb80c94b8c3f92bb46233681aa853e254926cacedc" => :x86_64_linux
  end

  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "make", "-f", OS.mac? ? "makefile.macosx" : "Makefile", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
  end
end
