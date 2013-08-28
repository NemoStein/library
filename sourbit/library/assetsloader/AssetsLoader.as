package sourbit.library.assetsloader
{
	/**
	 * Depends upon org.as3commons.bytecode
	 */
	public class AssetsLoader
	{
		static private var _textTypes:Vector.<String> = new <String>["txt", "xml", "json"];
		static private var _classPackage:String = "sourbit.assets";
		
		static public function setTextTypes(... types:Array):void
		{
			_textTypes = Vector.<String>(types);
		}
		
		static public function setClassesPackage(value:String):void
		{
			_classPackage = value;
		}
		
		static public function load(callback:Function, ... paths:Array):void
		{
			var assetCount:int = paths.length;
			var assetMap:Object = {};
			
			function batchCallback(assetPath:*, assetClass:Class):void
			{
				assetMap[assetPath] = assetClass;
				
				if (--assetCount == 0)
				{
					callback(assetMap);
				}
			}
			
			for each (var path:*in paths)
			{
				if (path is Class)
				{
					batchCallback(path, path);
				}
				else
				{
					var pathString:String = String(path);
					var parts:Array = pathString.split(".");
					var extension:String = parts[parts.length - 1];
					var type:Class = AssetElementLoader.BYNARY;
					
					if (extension == "jpeg" || extension == "jpg" || extension == "png" || extension == "gif")
					{
						type = AssetElementLoader.IMAGE;
					}
					else if (extension == "mp3")
					{
						type = AssetElementLoader.AUDIO;
					}
					else if (_textTypes.indexOf(extension) > -1)
					{
						type = AssetElementLoader.TEXT;
					}
					
					var loader:AssetElementLoader = new AssetElementLoader(pathString, type, _classPackage);
					loader.load(batchCallback);
				}
			}
		}
	}
}

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.as3commons.bytecode.abc.enum.Opcode;
import org.as3commons.bytecode.abc.LNamespace;
import org.as3commons.bytecode.abc.Multiname;
import org.as3commons.bytecode.abc.NamespaceSet;
import org.as3commons.bytecode.emit.IAbcBuilder;
import org.as3commons.bytecode.emit.IClassBuilder;
import org.as3commons.bytecode.emit.ICtorBuilder;
import org.as3commons.bytecode.emit.IMethodBuilder;
import org.as3commons.bytecode.emit.impl.AbcBuilder;
import org.as3commons.bytecode.emit.IPackageBuilder;
import org.as3commons.bytecode.emit.IPropertyBuilder;

internal class AssetElementLoader
{
	static public const TEXT:Class = String;
	static public const AUDIO:Class = Sound;
	static public const IMAGE:Class = Bitmap;
	static public const BYNARY:Class = ByteArray;
	
	private var _path:String;
	private var _type:Class;
	private var _className:String;
	
	private var _data:*;
	
	private var _loader:URLLoader;
	private var _callback:Function;
	private var _classPackage:String;
	
	public function AssetElementLoader(path:String, type:Class, classPackage:String)
	{
		_classPackage = classPackage;
		_path = path;
		_type = type;
		_className = _path.replace(/[^a-zA-Z0-9]+/g, "_");
	}
	
	public function load(callback:Function = null):void
	{
		_callback = callback;
		
		_loader = new URLLoader();
		_loader.dataFormat = URLLoaderDataFormat.BINARY;
		_loader.addEventListener(Event.COMPLETE, onLoaderComplete);
		_loader.load(new URLRequest(_path));
	}
	
	public function onLoaderComplete(event:Event):void
	{
		_loader.removeEventListener(Event.COMPLETE, onLoaderComplete);
		
		if (_type == IMAGE)
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderInfoComplete);
			loader.loadBytes(_loader.data);
		}
		else if (_type == TEXT)
		{
			buildClass(Object, _loader.data);
		}
		else
		{
			buildClass(_type, _loader.data);
		}
	}
	
	public function onLoaderInfoComplete(event:Event):void
	{
		buildClass(IMAGE, Bitmap(LoaderInfo(event.target).loader.content).bitmapData);
	}
	
	public function buildClass(superType:Class, data:*):void
	{
		_data = data;
		
		var abcBuilder:IAbcBuilder = new AbcBuilder();
		var packageBuilder:IPackageBuilder = abcBuilder.definePackage(_classPackage);
		var classBuilder:IClassBuilder = packageBuilder.defineClass(_className, getQualifiedClassName(superType));
		var propertyBuilder:IPropertyBuilder = classBuilder.defineProperty("data", getQualifiedClassName(Object));
		
		propertyBuilder.isStatic = true;
		
		var ctorBuilder:ICtorBuilder;
		var namespaceSet:NamespaceSet = new NamespaceSet([LNamespace.PUBLIC]);
		
		if (_type == IMAGE)
		{
			ctorBuilder = classBuilder.defineConstructor();
			ctorBuilder.addOpcode(Opcode.getlocal_0).addOpcode(Opcode.pushscope).addOpcode(Opcode.getlocal_0)
				
				.addOpcode(Opcode.getlex, [new Multiname("data", namespaceSet)]).addOpcode(Opcode.callproperty, [new Multiname("clone", namespaceSet), 0]).addOpcode(Opcode.constructsuper, [1])
				
				.addOpcode(Opcode.returnvoid);
		}
		else if (_type == AUDIO)
		{
			ctorBuilder = classBuilder.defineConstructor();
			ctorBuilder.addOpcode(Opcode.getlocal_0).addOpcode(Opcode.pushscope).addOpcode(Opcode.getlocal_0)
				
				.addOpcode(Opcode.constructsuper, [0]).addOpcode(Opcode.findpropstrict, [new Multiname("loadCompressedDataFromByteArray", namespaceSet)]).addOpcode(Opcode.getlex, [new Multiname("data", namespaceSet)]).addOpcode(Opcode.getlex, [new Multiname("data", namespaceSet)]).addOpcode(Opcode.getproperty, [new Multiname("length", namespaceSet)]).addOpcode(Opcode.callpropvoid, [new Multiname("loadCompressedDataFromByteArray", namespaceSet), 2])
				
				.addOpcode(Opcode.returnvoid);
		}
		else if (_type == TEXT)
		{
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod("toString");
			methodBuilder.returnType = "String";
			methodBuilder.addOpcode(Opcode.getlocal_0).addOpcode(Opcode.pushscope)
				
				.addOpcode(Opcode.getlex, [new Multiname("data", namespaceSet)])
				
				.addOpcode(Opcode.returnvalue);
		}
		else
		{
			ctorBuilder = classBuilder.defineConstructor();
			ctorBuilder.addOpcode(Opcode.getlocal_0).addOpcode(Opcode.pushscope).addOpcode(Opcode.getlocal_0)
				
				.addOpcode(Opcode.constructsuper, [0]).addOpcode(Opcode.findpropstrict, [new Multiname("writeBytes", namespaceSet)]).addOpcode(Opcode.getlex, [new Multiname("data", namespaceSet)]).addOpcode(Opcode.callpropvoid, [new Multiname("writeBytes", namespaceSet), 1]).addOpcode(Opcode.findproperty, [new Multiname("position", namespaceSet)]).addOpcode(Opcode.pushbyte, [0]).addOpcode(Opcode.initproperty, [new Multiname("position", namespaceSet)])
				
				.addOpcode(Opcode.returnvoid);
		}
		
		abcBuilder.addEventListener(Event.COMPLETE, onAbcBuilderComplete);
		abcBuilder.buildAndLoad();
	}
	
	public function onAbcBuilderComplete(event:Event):void
	{
		var generatedClass:Object = getDefinitionByName(_classPackage + "." + _className);
		generatedClass.data = _data;
		
		_callback(_path, generatedClass);
		_callback = null;
	}
}