/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.file{	import com.hexagonstar.file.types.IFile;	import com.hexagonstar.signals.Signal;			/**	 * Interface for bulk files that are processed by BulkLoader or any of it's sub	 * classes.	 * 	 * @see com.hexagonstar.file.BulkLoader	 * @see com.hexagonstar.file.ZipLoader	 */	public interface IBulkFile	{		/**		 * Starts loading the bulk file. If the file is currently loading, a call to		 * this method has no effect.		 * 		 * @param useAbsoluteFilePath		 * @param preventCaching		 */		function load(useAbsoluteFilePath:Boolean, preventCaching:Boolean):void;						/**		 * Disposes the bulk file to free up system resources.		 */		function dispose():void;						/**		 * Returns a String Representation of the bulk file.		 * 		 * @return A String Representation of the bulk file.		 */		function toString():String;						/**		 * Indicates whether the BulkFile is currently loading or not.		 */		function get loading():Boolean;						/**		 * The file that is wrapped into the bulk file.		 * 		 * @see com.hexagonstar.io.file.types.IFile		 */		function get file():IFile;						/**		 * The load priority of the wrapped file.		 */		function get priority():Number;						/**		 * The weight value of the bulk file. Used for weighted loading.		 */		function get weight():int;						/**		 * An optional callback method that can be associated with the file.		 */		function get callback():Function;						/**		 * An optional array of parameters that can be associated with the file.		 */		function get params():Array;						/**		 * The current status of the bulk file.		 * 		 * @see com.hexagonstar.data.constants.Status		 */		function get status():String;		function set status(v:String):void;						/**		 * How many times the loader retries to load the bulk file if it failed		 * loading. The default is 0.		 */		function get retryCount():int;		function set retryCount(v:int):void;						/**		 * The bulk file's currently loaded bytes.		 */		function get bytesLoaded():uint;						/**		 * The bulk file's total bytes.		 */		function get bytesTotal():uint;						/**		 * The bulk file's load progress in percent.		 */		function get percentLoaded():Number;						function get fileOpenSignal():Signal;		function get fileProgressSignal():Signal;		function get fileCompleteSignal():Signal;		function get fileHTTPStatusSignal():Signal;		function get fileIOErrorSignal():Signal;		function get fileSecurityErrorSignal():Signal;	}}