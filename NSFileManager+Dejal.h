//
//  NSFileManager+Dejal.h
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


@interface NSFileManager (Dejal)

- (NSInteger)dejal_fileSizeAtPath:(NSString *)path;
- (NSDate *)dejal_fileCreationDateAtPath:(NSString *)path;
- (NSDate *)dejal_fileModificationDateAtPath:(NSString *)path;

- (BOOL)dejal_isDirectoryAtURL:(NSURL *)url;
- (BOOL)dejal_isDirectoryAtPath:(NSString *)path;

- (BOOL)dejal_renameItemAtURL:(NSURL *)url toFilename:(NSString *)filename deleteExisting:(BOOL)deleteExisting error:(NSError **)error;
- (BOOL)dejal_renameItemAtPath:(NSString *)path toFilename:(NSString *)filename deleteExisting:(BOOL)deleteExisting error:(NSError **)error;

- (BOOL)dejal_renameWorkingFile:(NSString *)workingPath forSuccess:(BOOL)success error:(NSError **)error;


- (BOOL)dejal_removeFileIfExistsAtPath:(NSString *)path;

+ (BOOL)dejal_backupPath:(NSString *)path;
- (BOOL)dejal_copyPath:(NSString *)path withSuffix:(NSString *)suffix replaceExisting:(BOOL)replace error:(NSError **)error;

- (NSArray *)dejal_pathsWithFragments:(NSArray *)fragments isExtension:(BOOL)isExtension
                         atPath:(NSString *)basePath deepScan:(BOOL)deep;
- (NSArray *)dejal_pathsAtPath:(NSString *)basePath deepScan:(BOOL)deep;
- (NSArray *)dejal_pathsWithExtensions:(NSArray *)extensions atPath:(NSString *)basePath deepScan:(BOOL)deep;
- (NSArray *)dejal_pathsWithExtension:(NSString *)extension atPath:(NSString *)basePath deepScan:(BOOL)deep;
- (NSArray *)dejal_pathsWithFilenames:(NSArray *)filenames atPath:(NSString *)basePath deepScan:(BOOL)deep;
- (NSArray *)dejal_pathsWithFilename:(NSString *)filename atPath:(NSString *)basePath deepScan:(BOOL)deep;

@end

