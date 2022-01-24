# === Class: nexus::package
#
# Install the Nexus package
#
class nexus::package {
  $nexus_archive   = "nexus-${nexus::version}-unix.tar.gz"
  $download_url    = "${nexus::download_site}/${nexus_archive}"
  $dl_file         = "${nexus::download_folder}/${nexus_archive}"
  $install_dir     = "${nexus::install_root}/nexus-${nexus::version}"

  archive { $dl_file:
    source        => $download_url,
    extract       => true,
    extract_path  => $nexus::install_root,
    checksum_url  => "${download_url}.sha1",
    checksum_type => 'sha1',
    proxy_server  => $nexus::download_proxy,
    creates       => $install_dir,
    user          => 'root',
    group         => 'root',
  }

  if $nexus::manage_work_dir {
    $directories = [
      $nexus::work_dir,
      "${nexus::work_dir}/etc",
      "${nexus::work_dir}/log",
      "${nexus::work_dir}/orient",
      "${nexus::work_dir}/tmp",
    ]

    file{ $directories:
      ensure  => directory,
      owner   => $nexus::user,
      group   => $nexus::group,
      require => Archive[ $dl_file ]
    }
  }
}
