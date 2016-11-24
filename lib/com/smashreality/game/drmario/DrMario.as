package com.smashreality.game.drmario 
{
	import com.smashreality.game.drmario.enums.BlockType;
	import com.smashreality.game.drmario.enums.PillRotation;
	import com.smashreality.game.drmario.events.GameEvent;
	import com.smashreality.game.drmario.models.Entity;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Barry Morwood
	 */
	public class DrMario extends EventDispatcher
	{	
		/* constant */
		private const LEVELMULTIPLIER:uint = 3;
		
		/* private */
		private var _enemiesRemaining:uint;
		private var _enemiesTotal:uint;
		private var _level:uint;
		private var _currentPill:Entity;
		private var _nextPill:Entity;
		private var _grid:Array = [];
		private var _gridWidth:uint;
		private var _gridHeight:uint;
		private var _renderCount:uint;
		private var _gameStat:String;
		
		/* static */
		public static var $:DrMario;

		public function DrMario(width:uint = 10, height:uint = 20) 
		{
			$ = this;
			
			_gridWidth = width;
			_gridHeight = height;
			
			init();
		}
		
		
		private function init() {
			
			_level = 1; 
			_renderCount = 0;
			
			gameLogic();

		}
		
		public function startLevel() {
			
			buildGrid();
			
			_currentPill = createPill();
			_nextPill  = createPill();
			
			_gameStat = GameEvent.LEVEL_READY;
			
			if (createEnemys())
				dispatchEvent(new GameEvent(GameEvent.LEVEL_READY));
		}
		
		public function nextLevel(){
			_level += 1;
			gameLogic();
		}
		
		private function gameLogic():void {
			_enemiesTotal = LEVELMULTIPLIER * _level;
			_enemiesRemaining = _enemiesTotal;
		}
		
		public function previousLevel(){
			_level -= 1;
			
			if (_level <= 0)
				_level = 1;
				
			startLevel();
		}
		
		public function resume() {
			_gameStat = GameEvent.LEVEL_READY;
		}

		public function pause() {
			_gameStat = GameEvent.PAUSED;
			
			dispatchEvent(new GameEvent(GameEvent.PAUSED));
		}


		private function gameover() {
			trace('game over');
			_gameStat = GameEvent.GAME_OVER;
			
			dispatchEvent(new GameEvent(GameEvent.GAME_OVER));
		}

		private function levelComplete(){
			trace('levelComplete');
			_gameStat = GameEvent.LEVEL_COMPLETE;
			dispatchEvent(new GameEvent(GameEvent.LEVEL_COMPLETE));
		}

		private function buildGrid(){
			//build grid
			for (var x = 0; x < _gridWidth; x++) {
				_grid[x] = [];
				for (var y = 0; y < _gridHeight; y++) {
					grid[x][y] = {target:null};
				}
			}
		}

		public function dropPill(){

			_currentPill.x = 0;
			_currentPill.y = -1;

			_currentPill.partner.x = _currentPill.x + 1;
			_currentPill.partner.y = _currentPill.y;
		}

		private function createPill():Entity {
			
			var asset = Math.round(Math.random() * 3) + 1;
		
			var master:Entity = new Entity();
			master.assetID = asset;
			master.x = 0;
			master.y = -1;
			master.pill_rotation = PillRotation.RIGHT;
			master.type = BlockType.PILL_MASTER;
			
			asset = Math.round(Math.random() * 3) + 1;

			var child:Entity = new Entity();
			child.assetID = asset;
			child.x = master.x + 1;
			child.y = -1;
			child.type = BlockType.PILL_CHILD;

			master.partner = child;
			child.partner = master;

			return master;

		}

		public function update():void {
			
			
			if(_gameStat != GameEvent.LEVEL_READY ){
				return;
			}

			// pill logic
			_renderCount++;
			
				
			if (_renderCount % 5 == 0 && _gameStat != GameEvent.GAME_OVER) {
				for (var x = 0; x < _gridWidth; x++) {
					for (var y = _gridHeight-1; y >= 0; y--) {
						var square:Object = getGridObject(x, y);
						
						if(square.target != null){
							if (square.target.type == BlockType.PILL_SINGLE && canMove({x:square.target.x, y:square.target.y + 1})) {
								moveDown(square.target);
								getGridObject(square.target.x, square.target.y).target = square.target;
								square.target = null;
							} else if(square.target.type == BlockType.PILL_CHILD || square.target.type == BlockType.PILL_MASTER){
								if(canMove({x:square.target.x, y:square.target.y + 1}) && canMove({x:square.target.partner.x, y:square.target.partner.y + 1})){
									var child = getGridObject(square.target.partner.x, square.target.partner.y);
									moveDown(square.target);
									getGridObject(square.target.x, square.target.y).target = square.target;
									getGridObject(child.target.x, child.target.y).target = child.target;
									square.target = null;
									child.target = null;
								}
							}
						}
					}
				}
			 }

			 check();

			if (_renderCount % 15 == 0 && _gameStat != GameEvent.GAME_OVER) {

				if (!canMove({x:_currentPill.x, y:_currentPill.y + 1}) || !canMove({x:_currentPill.partner.x, y:_currentPill.partner.y + 1})) {
					//need new pill
					
					if(_currentPill.y == -1){
						gameover();
					}else{
					
						if(_currentPill != null){
							getGridObject(_currentPill.x, _currentPill.y).target = _currentPill;
							getGridObject(_currentPill.partner.x, _currentPill.partner.y).target = _currentPill.partner;

							if(_currentPill.pill_rotation == PillRotation.BOTTOM || _currentPill.pill_rotation == PillRotation.TOP){
								_currentPill.type = BlockType.PILL_SINGLE;
								_currentPill.partner.type = BlockType.PILL_SINGLE;
							}
						}
						
						check();
						_currentPill = _nextPill;
						_nextPill = createPill();
						
						//TODO: let user know they can drop pill when ever
						dropPill();
						
					}
				}else{
					moveDown(_currentPill);
				}
			}
		}
		
		public function moveDownFast() {
			for (var i:int = 0; i < _gridHeight; i++) 
			{
				moveDown(_currentPill);
			}
		}
		

		public function moveLeft() {
			if(canMove({x:_currentPill.x - 1, y:_currentPill.y}) && canMove({x:_currentPill.partner.x - 1,y:_currentPill.partner.y})){
				_currentPill.x -= 1;
				_currentPill.partner.x -= 1;
			}
		}

		public function moveRight() {
			
			if(canMove({x:_currentPill.x + 1, y:_currentPill.y}) && canMove({x:_currentPill.partner.x + 1, y:_currentPill.partner.y})){
				_currentPill.x += 1;
				_currentPill.partner.x += 1;
			}
		}

		private function moveDown(obj) {
		
			if(obj.type == BlockType.PILL_SINGLE){
				if(canMove({x:obj.x, y:obj.y + 1})){
					obj.y += 1;
				}
			}else{
				if(canMove({x:obj.x, y:obj.y + 1}) && canMove({x:obj.partner.x, y:obj.partner.y + 1})){
					obj.y += 1;
					obj.partner.y += 1;
				}
			}
			
		}

		public function rotate() {
		
			switch(_currentPill.pill_rotation){
				case PillRotation.RIGHT:
					if(canMove({x:_currentPill.x , y:_currentPill.y}) && canMove({x:_currentPill.partner.x - 1, y:_currentPill.partner.y - 1})){
						_currentPill.partner.x -= 1;
						_currentPill.partner.y -= 1;
						_currentPill.pill_rotation = PillRotation.TOP;
					}
				break;
				
				case PillRotation.LEFT:
				
					if(canMove({x:_currentPill.x , y:_currentPill.y}) && canMove({x:_currentPill.partner.x + 1, y:_currentPill.partner.y + 1})){
						_currentPill.partner.x += 1;
						_currentPill.partner.y += 1;
						_currentPill.pill_rotation = PillRotation.BOTTOM;
					}
				break;
				
				case PillRotation.TOP:
				
					if(canMove({x:_currentPill.x, y:_currentPill.y}) && canMove({x:_currentPill.partner.x - 1, y:_currentPill.partner.y + 1})){
						_currentPill.partner.x -= 1;
						_currentPill.partner.y += 1;
						_currentPill.pill_rotation = PillRotation.LEFT;
					}
				break;
				
				case PillRotation.BOTTOM:
				
					if(canMove({x:_currentPill.x, y:_currentPill.y}) && canMove({x:_currentPill.partner.x + 1, y:_currentPill.partner.y - 1})){
						_currentPill.partner.x += 1;
						_currentPill.partner.y -= 1;
						_currentPill.pill_rotation = PillRotation.RIGHT;
					}
				break;
			}
		

		}
	   
		public function createEnemys() {
		
			var enemyCount:uint = _enemiesTotal;

			while(enemyCount){
				var asset = Math.round(Math.random() * 3) + 1;
				trace(asset);
				var item:Entity = new Entity();
				item.assetID = asset;
				
				item.x = Math.floor(Math.random() * _gridWidth);
				item.y = Math.floor(Math.random() * (Math.floor(_gridHeight/2)) + (Math.floor(_gridHeight/2)))
				item.x = Math.round(item.x);
				item.y = Math.round(item.y);
				
				if(getGridObject(item.x,item.y).target != null)
					continue;

				item.type = BlockType.VIRUS;
				getGridObject(item.x,item.y).target = item;
				
				enemyCount--;
			}

		return true;
		
		} 
		
		private function canMove(obj) {
			try{
				if(getGridObject(obj.x,obj.y).target != null)
					return false;
			}catch(e){ return false;}
			
			return true;
		}
		
		private function getGridObject(x,y):Object{

			try{
				return grid[x][y];
			}catch (e) { return null; }
			
			return null;
		}


		public function check(){
			var square:Object;
			var lastMatch:int = -1;
			var found:Array = [];
			
			for (var x = 0; x < _gridWidth; x++) {
				for (var y = 0; y < _gridHeight+1; y++) {
					 square = getGridObject(x,y);

						if(square == null){
							square = {target: null}
						 }

						if(square.target != null && lastMatch == -1)
							lastMatch = square.target.assetID;
						
						if(square.target != null && lastMatch == square.target.assetID ){
							found.push({x:x, y:y});
						}else{
							if (found.length > 3 ) {
								for(var r =0; r < found.length; r++){
									var ta = getGridObject(found[r].x, found[r].y).target;
									//TODO: let user know to remove the virus
									//TweenMax.to(ta,0.5, {width:0, height:0} )
									trace('found ' + ta);
									dispatchEvent(new GameEvent(GameEvent.GRID_ITEM_REMOVED, ta));

									if(getGridObject(found[r].x, found[r].y).target.type == BlockType.PILL_MASTER || getGridObject(found[r].x, found[r].y).target.type == BlockType.PILL_CHILD){
										getGridObject(found[r].x, found[r].y).target.partner.type = BlockType.PILL_SINGLE;   
									}


									getGridObject(found[r].x, found[r].y).target = null;
								}
							}
							
							found = [];
							
							if(square.target != null){
								lastMatch = square.target.assetID;
								found.push({x:x, y:y});
							}else{
								lastMatch = -1;
							}
							
						}
				}
			}
			
			lastMatch = -1;
			found = [];
			
			for (y = 0; y < _gridHeight; y++) {
				for (x = 0; x < _gridWidth+1; x++) {
					 square = getGridObject(x, y);

						 if(square == null){
							square = {target: null}
						 }
					 
						if(square.target != null && lastMatch == -1)
							lastMatch = square.target.assetID;
						
						if(square.target != null && lastMatch == square.target.assetID ){
							found.push({x:x, y:y});
						}else{
						
							if(found.length > 3 ){
								for( r =0; r < found.length; r++){
									ta = getGridObject(found[r].x, found[r].y).target;
									//TODO: might want to remove the object after
									//TweenMax.to(ta,0.5, {width:0, height:0} )
									trace('found 1 ' + ta);
									dispatchEvent(new GameEvent(GameEvent.GRID_ITEM_REMOVED, ta));

									if(getGridObject(found[r].x, found[r].y).target.type == BlockType.PILL_MASTER || getGridObject(found[r].x, found[r].y).target.type == BlockType.PILL_CHILD){
										getGridObject(found[r].x, found[r].y).target.partner.type = BlockType.PILL_SINGLE;   
									}

									getGridObject(found[r].x, found[r].y).target = null;
								}
							}
							
							found = [];
							if(square.target != null){
								lastMatch = square.target.assetID;
								found.push({x:x, y:y});
							}else{
								lastMatch = -1;
							}
						}
				}
			}

			enemyCheck();
		}
		
	   private function enemyCheck(){

		_enemiesRemaining = 0;

			for (var y:uint = 0; y < _gridHeight; y++) {
				for (var x:uint = 0; x < _gridWidth; x++) {
					var square = getGridObject(x, y);
					if(square.target != null){
						if(square.target.type == BlockType.VIRUS){
						   _enemiesRemaining++;
						}
					}
				}
			}

			if(_enemiesRemaining == 0){
				levelComplete();
			}			
		}
		
		public function getGridArray():Array 
		{
			var list:Array = new Array();
			
			for (var y:uint = 0; y < _gridHeight; y++) {
				for (var x:uint = 0; x < _gridWidth; x++) {
					list.push(getGridObject(x, y).target);
				}
			}
			
			return list;
		}
		
		public function get gridWidth():uint 
		{
			return _gridWidth;
		}
		
		public function get gridHeight():uint 
		{
			return _gridHeight;
		}
		
		public function get grid():Array 
		{
			return _grid;
		}
		
		public function get enemiesRemaining():uint 
		{
			return _enemiesRemaining;
		}
		
		public function get enemiesTotal():uint 
		{
			return _enemiesTotal;
		}
		
		public function get level():uint 
		{
			return _level;
		}
		
		public function get nextPill():Entity 
		{
			return _nextPill;
		}
		
		public function get currentPill():Entity 
		{
			return _currentPill;
		}
		
		public function get paused():Boolean 
		{
			return (_gameStat == GameEvent.PAUSED);
		}
	}
}