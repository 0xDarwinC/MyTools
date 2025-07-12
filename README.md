# All my utilities

deletefilesbyfilename - give it an expression to match, and it will delete all files with that expression in it.

apfix_subfixremover.py - this is very niche, but you can quickly configure it to remove parts of a filename from multiple files simultaneously. Like if they all have a common suffix.

keepOrDelete - goes through every zip file in your cwd, and asks you if you want to keep or delete. works very fast, and also shows you the preview of the uncompressed file size data that you're saving. really helpful if you have >100 files, and some of them are useless that you want to remove. can be rewritten pretty quickly to work for any type of file, not just zip, but you'll lose the file preview ability.

previewZipFilesize - looks through all the zips in your cwd, and tells you what the uncompressed file size will be.

fileMoverAndBackup/Rsync - Moves files from a source folder to a different device over SSH, using either scp or rsync. The rsync one needs both wsl rsync and rsync on the destination device. obviously, both devices need ssh enabled, this works best over a tailnet or a LAN.

MusicTrackNumRemover - niche, removes the tracknumbers from filenames. does not remove it from the metadata though
