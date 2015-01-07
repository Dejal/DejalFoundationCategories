//
//  NSFileManager+Dejal.m
//  Dejal Open Source Categories
//
//  Created by David Sinclair on Tue Mar 23 2004.
//  Copyright (c) 2004-2015 Dejal Systems, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSFileManager+Dejal.h"
#import "NSObject+Dejal.h"
#import "NSArray+Dejal.h"
#import "NSString+Dejal.h"


@implementation NSFileManager (Dejal)

/**
 Convenience method to return the size of the file specified in the path.
 
 @author DJS 2004-05.
*/

- (NSInteger)dejal_fileSizeAtPath:(NSString *)path
{
    NSDictionary *attributes = [self attributesOfItemAtPath:path error:nil];
    
    return [attributes[NSFileSize] integerValue];
}

/**
 Convenience method to return the creation date of the file specified in the path.
 
 @author DJS 2006-11.
*/

- (NSDate *)dejal_fileCreationDateAtPath:(NSString *)path;
{
    NSDictionary *attributes = [self attributesOfItemAtPath:path error:nil];
    
    return attributes[NSFileCreationDate];
}

/**
 Convenience method to return the modification date of the file specified in the path.
 
 @author DJS 2005-11.
*/

- (NSDate *)dejal_fileModificationDateAtPath:(NSString *)path;
{
    NSDictionary *attributes = [self attributesOfItemAtPath:path error:nil];
    
    return attributes[NSFileModificationDate];
}

/**
 Convenience method to return YES if the specified path is a directory, otherwise NO.
 
 @author DJS 2013-02.
*/

- (BOOL)dejal_isDirectoryAtURL:(NSURL *)url;
{
    BOOL isDirectory = NO;
    
    return ([self fileExistsAtPath:url.path isDirectory:&isDirectory]) && isDirectory;
}

/**
 Convenience method to return YES if the specified path is a directory, otherwise NO.
 
 @author DJS 2005-10.
*/

- (BOOL)dejal_isDirectoryAtPath:(NSString *)path;
{
    BOOL isDirectory = NO;
    
    return ([self fileExistsAtPath:path isDirectory:&isDirectory]) && isDirectory;
}

/**
 Renames the file or directory specified in the URL to have the specified filename, in the same location.  If deleteExisting is YES and the destination already exists, it is first deleted; otherwise an error will occur.  See the standard -movePath:toPath:handler: method description for details of the handler parameter and other relevant information.
 
 @author DJS 2004-03.
 @version DJS 2005-12: changed to handle a special case when just changing the case of the name.
 @version DJS 2011-05: changed to avoid using a deprecated method.
*/

- (BOOL)dejal_renameItemAtURL:(NSURL *)url toFilename:(NSString *)filename deleteExisting:(BOOL)deleteExisting error:(NSError **)error;
{
    NSURL *destination = [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:filename];
    
    // Special case: if the current name and the filename are equivalent, i.e. only differing in case, removing would be wrong and moving would fail, so we need to change the name:
    NSString *oldName = [url lastPathComponent];
    
    if ([oldName dejal_isEquivalentTo:filename])
    {
        NSURL *oldURL = url;
        NSString *tempName = [oldName stringByAppendingFormat:@"%.2f", [NSDate timeIntervalSinceReferenceDate]];
        
        url = [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:tempName];
        
        [self moveItemAtURL:oldURL toURL:url error:error];
    }
    
    if (deleteExisting)
        [self removeItemAtURL:destination error:nil];
    
    return [self moveItemAtURL:url toURL:destination error:error];
}

/**
 Renames the file or directory specified in the path to have the specified filename, in the same location.  If deleteExisting is YES and the destination already exists, it is first deleted; otherwise an error will occur.  See the standard -movePath:toPath:handler: method description for details of the handler parameter and other relevant information.
 
 @author DJS 2004-03.
 @version DJS 2005-12: changed to handle a special case when just changing the case of the name.
 @version DJS 2011-05: changed to avoid using a deprecated method.
*/

- (BOOL)dejal_renameItemAtPath:(NSString *)path toFilename:(NSString *)filename deleteExisting:(BOOL)deleteExisting error:(NSError **)error;
{
    NSString *destination = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
    
    // Special case: if the current name and the filename are equivalent, i.e. only differing in case, removing would be wrong and moving would fail, so we need to change the name:
    if ([[path lastPathComponent] dejal_isEquivalentTo:filename])
    {
        NSString *oldPath = path;
        
        path = [path stringByAppendingFormat:@"%.2f", [NSDate timeIntervalSinceReferenceDate]];
        
        [self moveItemAtPath:oldPath toPath:path error:error];
    }
    
    if (deleteExisting && [self fileExistsAtPath:destination])
        [self removeItemAtPath:destination error:error];
    
    return [self moveItemAtPath:path toPath:destination error:error];
}

/**
 Given a working file, i.e. one named with a tilde before the extension (see -[NSString backupFilePath]), swaps the working file and the previous final file (if any).
 
 @author DJS 2004-03.
 @version DJS 2011-05: changed to avoid using a deprecated method.
*/

- (BOOL)dejal_renameWorkingFile:(NSString *)workingPath forSuccess:(BOOL)success error:(NSError **)error;
{
    BOOL okay = YES;
    
    if (success)
    {
        NSString *basePath = [workingPath stringByDeletingLastPathComponent];
        NSString *extension = [workingPath pathExtension];
        NSString *workingFilename = [workingPath lastPathComponent];
        NSString *workingBase = [workingFilename stringByDeletingPathExtension];
        NSString *finalFilename = [workingBase substringToIndex:[workingBase length] - 1];
        NSString *tempFilename = [workingBase stringByAppendingString:@"~"];
        
        if ([extension length])
        {
            finalFilename = [finalFilename stringByAppendingPathExtension:extension];
            tempFilename = [tempFilename stringByAppendingPathExtension:extension];
        }
        
        NSString *finalPath = [basePath stringByAppendingPathComponent:finalFilename];
        NSString *tempPath = [basePath stringByAppendingPathComponent:tempFilename];
        
        // Rename the working file with an extra tilde on the end:
        okay = [self dejal_renameItemAtPath:workingPath toFilename:tempFilename deleteExisting:YES error:error];
        
        // Rename the previous file the same as the working file was:
        if ([self fileExistsAtPath:finalPath])
            okay = okay && [self dejal_renameItemAtPath:finalPath toFilename:workingFilename deleteExisting:NO error:error];
        
        // Rename the working file the same as the previous file was:
        okay = okay && [self dejal_renameItemAtPath:tempPath toFilename:finalFilename deleteExisting:NO error:error];
    }
    else
    {
        // Failed, so just delete the working file:
        okay = [self removeItemAtPath:workingPath error:error];
    }
    
    return okay;
}


/**
 If a file or folder exists at the path, it is blindly removed.  As with -removeFileAtPath:handler:, use caution with this method.  Returns YES if the file didn't exist, or was successsfully removed, or NO if it couldn't be removed.
 
 @author DJS 2004-06.
*/

- (BOOL)dejal_removeFileIfExistsAtPath:(NSString *)path
{
    if ([self fileExistsAtPath:path])
        return [self removeItemAtPath:path error:nil];
    else
        return YES;
}

/**
 Convenience class method to duplicate the path with a " backup" suffix, replacing any old backup.
 
 @author DJS 2007-04.
*/

+ (BOOL)dejal_backupPath:(NSString *)path;
{
    return [[self defaultManager] dejal_copyPath:path withSuffix:@" backup" replaceExisting:YES error:nil];
}

/**
 Like -copyFile:toPath:handler:, but simply uses the same path as the destination with the suffix appended.  Does nothing if no file exists at the specified path, or the suffix is empty.  Optionally deletes any old file at the new path first.  This is particularly useful for doing duplicate operations or backups of files or folders.
 
 @author DJS 2007-04.
 @version DJS 2011-05 changed to avoid using a deprecated method.
*/

- (BOOL)dejal_copyPath:(NSString *)path withSuffix:(NSString *)suffix replaceExisting:(BOOL)replace error:(NSError **)error;
{
    if ([self fileExistsAtPath:path] && [suffix length])
    {
        NSString *destPath = [[path stringByDeletingPathExtension] stringByAppendingString:suffix];
        destPath = [destPath stringByAppendingPathExtension:[path pathExtension]];
        
        if (replace)
            [self dejal_removeFileIfExistsAtPath:destPath];
        
        return [self copyItemAtPath:path toPath:destPath error:error];
    }
    else
        return NO;
}

/**
 Given an array of filenames or extensions (which may be nil or empty) and a directory path, returns an array of full paths that have those filenames or extensions (or all files if no fragments provided) within that directory.  If deep is YES, all subdirectories are scanned, otherwise only the base one is scanned.  If the base path isn't present, or isn't a directory, nil is returned.  The base path may include a tilde.  See also the following more specific methods.
 
 @author DJS 2005-05.
 @version DJS 2005-10: changed to add support for filenames.
 @version DJS 2008-01: changed to sort in Finder order.
*/

- (NSArray *)dejal_pathsWithFragments:(NSArray *)fragments isExtension:(BOOL)isExtension
                         atPath:(NSString *)basePath deepScan:(BOOL)deep;
{
    basePath = [basePath dejal_expandedPath];
    BOOL isDirectory = NO;
    
    if (![self fileExistsAtPath:basePath isDirectory:&isDirectory] || !isDirectory)
        return nil;
    
    NSMutableArray *paths = [NSMutableArray array];
    NSArray *subpaths;
    
    if (deep)
        subpaths = [self subpathsAtPath:basePath];
    else
        subpaths = [self contentsOfDirectoryAtPath:basePath error:nil];
    
    subpaths = [subpaths dejal_sortedArrayUsingFinderOrder];
    
    for (NSString *subpath in subpaths)
    {
        NSString *want = isExtension ? [subpath pathExtension] : [subpath dejal_lastPathComponentWithoutExtension];
        
        if (!fragments || [fragments dejal_containsObjectEquivalentTo:want])
            [paths addObject:[basePath stringByAppendingPathComponent:subpath]];
    }
    
    return paths;
}

/**
 Given a directory path, returns an array of full paths within that directory.  If deep is YES, all subdirectories are scanned, otherwise only the base one is scanned.  If the base path isn't present, or isn't a directory, nil is returned.  The base path may include a tilde.
 
 @author DJS 2007-02.
*/

- (NSArray *)dejal_pathsAtPath:(NSString *)basePath deepScan:(BOOL)deep;
{
    return [self dejal_pathsWithFragments:nil isExtension:NO atPath:basePath deepScan:deep];
}

/**
 Given an array of extensions (which may be nil or empty) and a directory path, returns an array of full paths that have those extensions (or all files if no extensions provided) within that directory.  If deep is YES, all subdirectories are scanned, otherwise only the base one is scanned.  If the base path isn't present, or isn't a directory, nil is returned.  The base path may include a tilde.  See also -pathsWithExtension:atPath:deepScan:.
 
 @author DJS 2005-05.
*/

- (NSArray *)dejal_pathsWithExtensions:(NSArray *)extensions atPath:(NSString *)basePath deepScan:(BOOL)deep
{
    return [self dejal_pathsWithFragments:extensions isExtension:YES atPath:basePath deepScan:deep];
}

/**
 Given an extension (which may be nil or blank) and a directory path, returns an array of full paths that have that extension (or all files if no extension provided) within that directory.  If deep is YES, all subdirectories are scanned, otherwise only the base one is scanned.  If the base path isn't present, or isn't a directory, nil is returned.  The base path may include a tilde.  See also -pathsWithExtensions:atPath:deepScan:.
 
 @author DJS 2005-05.
*/

- (NSArray *)dejal_pathsWithExtension:(NSString *)extension atPath:(NSString *)basePath deepScan:(BOOL)deep
{
    NSArray *paths;
    
    if (![extension length])
        paths = [self dejal_pathsWithExtensions:nil atPath:basePath deepScan:deep];
    else
        paths = [self dejal_pathsWithExtensions:@[extension] atPath:basePath deepScan:deep];
    
    return paths;
}

/**
 Given an array of filenames without extensions (which may be nil or empty) and a directory path, returns an array of full paths that have those filenames (or all files if no filenames provided) within that directory.  If deep is YES, all subdirectories are scanned, otherwise only the base one is scanned.  If the base path isn't present, or isn't a directory, nil is returned.  The base path may include a tilde.  See also -pathsWithFilename:atPath:deepScan:.
 
 @author DJS 2005-10.
 */

- (NSArray *)dejal_pathsWithFilenames:(NSArray *)filenames atPath:(NSString *)basePath deepScan:(BOOL)deep
{
    return [self dejal_pathsWithFragments:filenames isExtension:NO atPath:basePath deepScan:deep];
}

/**
 Given a filename without an extension (which may be nil or blank) and a directory path, returns an array of full paths that have that filename (or all files if no filename provided) within that directory.  If deep is YES, all subdirectories are scanned, otherwise only the base one is scanned.  If the base path isn't present, or isn't a directory, nil is returned.  The base path may include a tilde.  See also -pathsWithFilenames:atPath:deepScan:.
 
 @author DJS 2005-10.
 */

- (NSArray *)dejal_pathsWithFilename:(NSString *)filename atPath:(NSString *)basePath deepScan:(BOOL)deep
{
    NSArray *paths;
    
    if (![filename length])
        paths = [self dejal_pathsWithFilenames:nil atPath:basePath deepScan:deep];
    else
        paths = [self dejal_pathsWithFilenames:@[filename] atPath:basePath deepScan:deep];
    
    return paths;
}

@end

