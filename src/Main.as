package
{
	import com.greensock.easing.*;
	import com.greensock.TweenMax;
	import com.smashreality.finq.FinqObj;
	import com.smashreality.game.drmario.DrMario;
	import com.smashreality.game.drmario.enums.BlockType;
	import com.smashreality.game.drmario.events.GameEvent;
	import com.smashreality.game.drmario.models.Entity;
	import flare.materials.filters.ColorFilter;
	import flare.materials.Material3D;
	import flare.materials.Shader3D;
	import flare.primitives.Cube;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.PressAndTapGestureEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import ui.Asset;
	import ui.GameOverScreen;
	import ui.GameScreen;
	import ui.PauseScreen;
	import ui.StartScreen;
	import ui.WinScreen;
	
	import flare.basic.*;
	import flare.collisions.*;
	import flare.core.*;
	import flare.system.*;
	import flare.utils.*;
	
	/**
	 * ...
	 * @author Barry Morwood
	 */
	[SWF(frameRate = 60, width = 400, height = 500, backgroundColor = 0x000000)]
	public class Main extends MovieClip 
	{
		private var scene:Scene3D;

		private var winScreen:WinScreen;
		private var startScreen:StartScreen;
		private var movingPill:Boolean;
		private var gridData:GameScreen;
		private var gridData2:Pivot3D;
		
		
		/* game variables */
	
		var intro_screen:Boolean = true;
		var pill:Cube;
		var pillSlave:Cube;
		var gridSize:uint = 20;
		var offset:Number = gridSize/2;
		var nextPill:Cube;
		var pauseScreen:PauseScreen;
		var paused:Boolean = false;
		var startScreenMode:Boolean = true;
		var gameoverScreen:GameOverScreen;
		var buildScreen:Boolean = true;
		var stageWidth:Number = 400;
		var stageHeight:Number = 500;
		
		public static var $:Main;
		
		private var _dm:DrMario;
		private var nextPillSlave:Cube;
		private var nextPillMaster:Cube;

		public function Main() 
		{
			trace('init');	
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyActions);
			
			scene = new Viewer3D(this);
			scene.antialias = 2;
			scene.camera = new Camera3D();
			scene.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent );
			scene.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
			//scene.pause();
			
			$ = this;
			
			_dm = new DrMario(10, 20);
			_dm.addEventListener(GameEvent.GAME_OVER, function () {
				gameover();
				});
				
			_dm.addEventListener(GameEvent.LEVEL_COMPLETE, function () {
				levelComplete();
				});
				
			_dm.addEventListener(GameEvent.GRID_ITEM_REMOVED, function (e:GameEvent) {

				var entity:Entity = e.item as Entity;
				var item:Cube = gridData2.getChildByName(entity.guid.toString()) as Cube;
				
				
				if (item == null) return;
				
				trace(item.getMaterialByName('main-mat'));
				
				var objParams:Object = { a: ((item.getMaterialByName('main-mat') as Shader3D).filters[0] as ColorFilter).a };
					
				TweenMax.to(objParams, 1,  { a:0, onUpdate:function (obj, item) {
						((item.getMaterialByName('main-mat') as Shader3D).filters[0] as ColorFilter).a = obj.a;
						
						if (obj.a <= 0.01) {
							item.visible = false;
							gridData2.removeChild(item);
						}
					}, onUpdateParams:[objParams, item] } );
				
				});
			
			//paused screen
			pauseScreen = new PauseScreen(); 
			pauseScreen.x = (stageWidth / 2);
			pauseScreen.y = (stageHeight / 2);
			pauseScreen.alpha = 1;


			//game over screen 
			gameoverScreen = new GameOverScreen();
			gameoverScreen.x = (stageWidth / 2) ;
			gameoverScreen.y = (stageHeight / 2) ;
			gameoverScreen.alpha = 0;

			//win screen 
			winScreen = new WinScreen();//new Sprite(context, "images/winner_screen.png");
			winScreen.x = (stageWidth / 2);
			winScreen.y = (stageHeight / 2);
			winScreen.alpha = 0;

			init();
		}
		
		private function progressEvent(e:Event):void 
		{
			trace( scene.loadProgress );
		}
		
		var container:Pivot3D;
		private function completeEvent(e:Event):void 
		{

		}
		
		private function updateEvent(e:Event):void 
		{
			//trace('updating');
			
			//Pivot3DUtils.setPositionWithReference( scene.camera, 0, 80, -20, container, 0.1 );
			//Pivot3DUtils.lookAtWithReference( scene.camera, 0, 0, 0, container, container.getDir(), 0.05 );
		}
		
		
		public function init() {
			intro_screen = true;
			startScreenMode = true;
			startScreenIntro();
			
			trace('addChild cube');
			
			scene.resume();
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
			

			
		}
		
		//yellow, red, blue, green
		var colors:Array = [0x000000, 0xd62525, 0x4225d6, 0x3ebb1c ];
		public function createAsset(obj:Entity):Cube {

			var cube:Cube = new Cube(obj.guid.toString(), 1, 1, 1);

			cube.setMaterial(getMaterial(obj.assetID, (obj.type == BlockType.VIRUS)));

			return cube;
		}
		
		public function getMaterial(assetID:uint, isVirus:Boolean = false ):Shader3D {
			var mat:Shader3D = new Shader3D('main-mat');
			var color:ColorFilter;

			color = new ColorFilter(colors[assetID - 1]);
			
			if (isVirus){
				color.a = 0.75;
				}
			
			mat.filters = [color];
			
			return mat;
		}

		public function startScreenIntro(){
	
	        //start screen
			startScreen = new StartScreen();
			addChild(startScreen);
			
			startScreen.x = (stageWidth / 2);
			startScreen.y = (stageHeight / 2) ;
			startScreen.alpha = 1;
			
		}

		public function gameover(){
			gameoverScreen.alpha = 1;
			addChild(gameoverScreen);
		}

		public function levelComplete(){
			trace('levelComplete');
			winScreen.alpha = 1;
			addChild(winScreen);
		}
		
		public function buildGameScreen():void 
		{

			
			var mat:Shader3D = new Shader3D();
			mat.filters = [new ColorFilter(0xffffff, 0.5)]
			
			var cube:Cube = new Cube('bottle', _dm.gridWidth, _dm.gridHeight, 1);
			cube.x = _dm.gridWidth/2;
			cube.y = (_dm.gridHeight/2) * -1;
			cube.setMaterial(mat);
			
			container = new Pivot3D();
			container.addChild( cube );
			scene.addChild( container );
			
			container.x = (cube.width / 2) * -1;
			container.y = cube.height / 2;
			
			Pivot3DUtils.setPositionWithReference( scene.camera, -15,0, -150, container, 0.1 );
			//Pivot3DUtils.lookAtWithReference( scene.camera, 0, 0, 0, container, container.getDir(), 0.05 );

			gridData2 = new Pivot3D();
			//gridData2.x = 100;
			
			scene.addChild(gridData2);

			if(contains(startScreen))
				removeChild(startScreen);

			intro_screen = false;

			nextPillMaster = new Cube('next-pill', 1,1,1);
			nextPillMaster.x = -7;
			nextPillMaster.y = 4;
			nextPillMaster.z = -1;
	
			nextPillSlave = new Cube('next-pill-slave', 1,1,1);
			nextPillSlave.x = nextPillMaster.x + nextPillMaster.width;
			nextPillSlave.y = nextPillMaster.y;
			nextPillSlave.z = -1;

			pill = new Cube('pill', 1,1,1);
			pill.z = -1;
			
			pillSlave = new Cube('pill-slave', 1,1,1);
			pillSlave.x = pill.x + pill.width;
			pillSlave.y = pill.y;
			pillSlave.z = -1;

			scene.addChild(pill);
			scene.addChild(pillSlave);
			scene.addChild(nextPillMaster);
			scene.addChild(nextPillSlave);
			
			addEventListener(Event.ENTER_FRAME, update);
		}

		public function startLevel() {
			
			if(gridData2 != null)
				scene.removeChild(gridData2);
			
			gridData2 = new Pivot3D();
			
			scene.addChild(gridData2);
				
			//gridData2.forEach(function (e:Pivot3D) { 
				//gridData2.removeChild(e);
				//} );
			
			if(contains(winScreen))
				removeChild(winScreen);
			
			if(contains(gameoverScreen))
				removeChild(gameoverScreen);
			
			_dm.startLevel();
			
			_dm.dropPill();
			

		}

		public function nextLevel() {
			_dm.nextLevel();
			startLevel();
		}
		
		public function keyActions(e:KeyboardEvent){
				//trace("e.keyCode " + e.keyCode);
				//trace("e.charCode " + e.charCode);
				if (e.keyCode == 39) {
					_dm.moveRight();
					e.preventDefault();
				}

				if (e.keyCode == 37) {
					_dm.moveLeft();
					e.preventDefault();
				}

				if (e.keyCode == 40) {
					//moveDown(pill);
					_dm.moveDownFast();
					e.preventDefault();
				}

				if (e.keyCode == 38) {
					_dm.rotate();
					e.preventDefault();
				}

				//pause 'P'
				if (e.charCode == 112 || e.keyCode == 80) {

					if(!_dm.paused)
						pause();
					else
						resume();
				}
				

				//next 'N'
				 
				if (e.charCode == 110 || e.keyCode == 78) {
					nextLevel();
				}
				
				//next 'S'
				
				if (e.charCode == 115 || e.keyCode == 83) {
					if(buildScreen){
						buildGameScreen();
						buildScreen = false;
					}
					startLevel();
				}
				

		}
		
		public function resume() {
			_dm.resume();
			
			if(contains(pauseScreen))
				removeChild(pauseScreen);
		}

		public function pause() {
			_dm.pause();
			addChild(pauseScreen);
		}

		public function update(e:Event):void {
			
			
			
			//gridData['level_txt'].text = "level " + _dm.level;
			//gridData['virus_txt'].text = "enemies " + _dm.enemiesRemaining;
			
			for each(var obj:Entity in _dm.getGridArray()) {
				
				if (obj == null)
					continue;
					
				var item:Cube = gridData2.getChildByName(obj.guid.toString()) as Cube;

				if (item == null){
					item = createAsset(obj);
					gridData2.addChild(item);
				}
				
				item.x = (obj.x) + container.x+ 0.5;
				item.y = (obj.y * -1) + container.y - 0.5;
				item.z = -1;
			}
			
			pill.x = (_dm.currentPill.x + container.x) + 0.5;
			pill.y = (_dm.currentPill.y * -1) + container.y - 0.5;
			pill.setMaterial(getMaterial(_dm.currentPill.assetID));
			//pill.gotoAndStop(_dm.currentPill.assetID);
			
			pillSlave.x = (_dm.currentPill.partner.x + container.x) + 0.5;
			pillSlave.y = (_dm.currentPill.partner.y * -1) + container.y - 0.5;
			pillSlave.setMaterial(getMaterial(_dm.currentPill.partner.assetID));
			//pillSlave.gotoAndStop(_dm.currentPill.partner.assetID);
			
			nextPillMaster.setMaterial(getMaterial(_dm.nextPill.assetID));
			nextPillSlave.setMaterial(getMaterial(_dm.nextPill.partner.assetID));
			
			//Pivot3DUtils.setPositionWithReference( scene.camera, 0, -15, -30, container, 0.1 );
			//Pivot3DUtils.lookAtWithReference( scene.camera, 0, 0, 0, container, container.getDir(), 0.05 );
			_dm.update();
		}
	}
}