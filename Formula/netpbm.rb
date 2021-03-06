class Netpbm < Formula
  desc "Image manipulation"
  homepage "http://netpbm.sourceforge.net"
  # Maintainers: Look at https://sourceforge.net/p/netpbm/code/HEAD/tree/
  # for stable versions and matching revisions.
  url "http://svn.code.sf.net/p/netpbm/code/stable", :revision => 2885
  version "10.73.07"
  version_scheme 1

  head "http://svn.code.sf.net/p/netpbm/code/trunk"

  bottle do
    cellar :any
    sha256 "6fbf190d0c7876dd811872d273d780fe1404672abb85aec666f44bcf3f643581" => :sierra
    sha256 "e3551086519cfe08637b239c3e3939f3a9cfb416c7795f8d08ef1357551f922b" => :el_capitan
    sha256 "fb5df9f31a1202bf9a25cabb48a3d67a35dabbaa645875e558c4a359da784fa9" => :yosemite
    sha256 "e52905b4bdaaf22d2507e5957d6d0b195627394fe5a0942b7741d5408c5cb549" => :x86_64_linux
  end

  option :universal

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  unless OS.mac?
    depends_on "flex"
    depends_on "zlib"
  end

  def install
    ENV.universal_binary if build.universal?

    cp "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      if OS.linux?
        s.change_make_var! "CFLAGS_SHLIB", "-fPIC"
      elsif OS.mac?
        s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
        s.change_make_var! "NETPBMLIBTYPE", "dylib"
        s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
        s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      end
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{Formula["jasper"].opt_include}/jasper"
    end

    ENV.deparallelize
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"

    cd "stage" do
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w[bin include lib misc]
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir["man/man1/*.1"]
      man5.install Dir["man/man5/*.5"]
      lib.install Dir["link/*.a"]
      lib.install Dir["link/*.dylib"] if OS.mac?
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end

    (bin/"doc.url").unlink
  end

  test do
    fwrite = Utils.popen_read("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam")
    (testpath/"test.pam").write fwrite
    system "#{bin}/pamdice", "test.pam", "-outstem", testpath/"testing"
    assert File.exist?("testing_0_0.")
  end
end
