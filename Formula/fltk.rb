class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "http://www.fltk.org/"
  url "https://fossies.org/linux/misc/fltk-1.3.4-source.tar.gz"
  sha256 "c8ab01c4e860d53e11d40dc28f98d2fe9c85aaf6dbb5af50fd6e66afec3dc58f"

  bottle do
    sha256 "145440139990f28366947502ac96c89ecea165dd6e328b30495291ea55b0bd17" => :sierra
    sha256 "8fc20e6d86ac3c9866b614365b25942cba95855ae748f284848224df9de7c90d" => :el_capitan
    sha256 "b30e0f6d843720c277f5e2c393abb2505d2fe69c8335c152f645ce87cc91d735" => :yosemite
    sha256 "e93feba5b2a3c5482393592f6c0533558dcf9be6ad2b23c1ebaf800c9b101d47" => :x86_64_linux
  end

  depends_on "libpng"
  depends_on "jpeg"
  unless OS.mac?
    depends_on :x11
    depends_on "linuxbrew/xorg/mesa" => :recommended
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
