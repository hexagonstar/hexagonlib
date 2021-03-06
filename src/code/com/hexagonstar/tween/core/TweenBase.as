/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package com.hexagonstar.tween.core
{
	import com.hexagonstar.tween.Tween;
	import com.hexagonstar.tween.TweenVars;
	
	
	/**
	 * TweenBase is the base class for all Tween, TweenPro, Timeline, and
	 * TimelinePro classes and provides core functionality and properties. There is no
	 * reason to use this class directly.
	 */
	public class TweenBase
	{
		//-----------------------------------------------------------------------------------------
		// Constants
		//-----------------------------------------------------------------------------------------
		
		/** @private */
		public static const MULTIPLE:String = "_MULTIPLE_";
		/** @private */
		public static const TIME_SCALE:String = "timeScale";
		/** @private */
		public static const CHANGE_FACTOR:String = "changeFactor";
		
		
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public static const version:Number = 1.693;
		
		/**
		 * @private
		 */
		protected static var _classInitialized:Boolean;
		
		/**
		 * Delay in seconds (or frames for frames-based tweens/timelines)
		 * @private
		 */
		protected var _delay:Number;
		
		/**
		 * Has onUpdate. Tracking this as a Boolean value is faster than checking
		 * this.vars.onUpdate != null.
		 * 
		 * @private
		 **/
		protected var _hasUpdate:Boolean;
		
		/**
		 * Primarily used for zero-duration tweens to determine the direction/momentum of
		 * time which controls whether the starting or ending values should be rendered.
		 * For example, if a zero-duration tween renders and then its timeline reverses
		 * and goes back before the startTime, the zero-duration tween must render the
		 * starting values. Otherwise, if the render time is zero or later, it should
		 * always render the ending values.
		 * 
		 * @private
		 **/
		protected var _rawPrevTime:Number = -1;
		
		/**
		 * Stores variables (things like alpha, y or whatever we're tweening as well as
		 * special properties like "onComplete").
		 **/
		public var vars:TweenVars;
		
		/**
		 * The tween has begun and is now active.
		 */
		public var active:Boolean;
		
		/**
		 * Flagged for garbage collection.
		 */
		public var gc:Boolean;
		
		/**
		 * Indicates whether or not init() has been called (where all the tween property
		 * start/end value information is recorded)
		 **/
		public var initialized:Boolean;
		
		/**
		 * The parent timeline on which the tween/timeline is placed. By default, it uses
		 * the Tween.rootTimeline (or Tween.rootFramesTimeline for frames-based
		 * tweens/timelines).
		 **/
		public var timeline:TimelineBase;
		
		/**
		 * Start time in seconds (or frames for frames-based tweens/timelines), according
		 * to its position on its parent timeline
		 * 
		 * @private
		 **/
		public var cachedStartTime:Number;
		
		/**
		 * The last rendered currentTime of this TweenBase. If a tween is going to repeat,
		 * its cachedTime will reset even though the cachedTotalTime continues linearly
		 * (or if it yoyos, the cachedTime may go forwards and backwards several times
		 * over the course of the tween). The cachedTime reflects the tween's "local"
		 * (which can never exceed the duration) time whereas the cachedTotalTime reflects
		 * the overall time. These will always match if the tween doesn't repeat/yoyo.
		 * 
		 * @private
		 **/
		public var cachedTime:Number;
		
		/**
		 * The last rendered totalTime of this TweenBase. It is prefaced with "cached"
		 * because using a public property like this is faster than using the getter which
		 * is essentially a function call. If you want to update the value, you should
		 * always use the normal property, like myTween.totalTime = 0.5.
		 * 
		 * @private
		 **/
		public var cachedTotalTime:Number;
		
		/**
		 * Prefaced with "cached" because using a public property like this is faster than
		 * using the getter which is essentially a function call. If you want to update
		 * the value, you should always use the normal property, like myTween.duration =
		 * 0.5.
		 * 
		 * @private
		 **/
		public var cachedDuration:Number;
		
		/**
		 * Prefaced with "cached" because using a public property like this is faster than
		 * using the getter which is essentially a function call. If you want to update
		 * the value, you should always use the normal property, like
		 * myTween.totalDuration = 0.5.
		 * 
		 * @private
		 **/
		public var cachedTotalDuration:Number;
		
		/**
		 * timeScale allows you to slow down or speed up a tween/timeline. 1 = normal
		 * speed, 0.5 = half speed, 2 = double speed, etc. It is prefaced with "cached"
		 * because using a public property like this is faster than using the getter which
		 * is essentially a function call. If you want to update the value, you should
		 * always use the normal property, like myTween.timeScale = 2
		 * 
		 * @private
		 **/
		public var cachedTimeScale:Number;
		
		/**
		 * Parent timeline's rawTime at which the tween/timeline was paused (so that we
		 * can place it at the appropriate time when it is unpaused). NaN when the
		 * tween/timeline isn't paused.
		 * 
		 * @private
		 **/
		public var cachedPauseTime:Number;
		
		/**
		 * Indicates whether or not the tween is reversed.
		 */
		public var cachedReversed:Boolean;
		
		/**
		 * Next TweenBase object in the linked list.
		 */
		public var nextNode:TweenBase;
		
		/**
		 * Previous TweenBase object in the linked list.
		 */
		public var prevNode:TweenBase;
		
		/**
		 * When a TweenBase has been removed from its timeline, it is considered an
		 * orphan. When it it added to a timeline, it is no longer an orphan. We don't
		 * just set its "timeline" property to null because we need to always keep track
		 * of the timeline in case the TweenBase is enabled again by restart() or
		 * basically any operation that would cause it to become active again. "cachedGC"
		 * is different in that a TweenBase could be eligible for gc yet not removed from
		 * its timeline, like when a Timeline completes for example.
		 * 
		 * @private
		 **/
		public var cachedOrphan:Boolean;
		
		/**
		 * Indicates that the duration or totalDuration may need refreshing (like if a
		 * Timeline's child had a change in duration or startTime). This is another
		 * performance booster because if the cache isn't dirty, we can quickly read from
		 * the cachedDuration and/or cachedTotalDuration.
		 * 
		 * @private
		 **/
		public var cacheIsDirty:Boolean;
		
		/**
		 * Quicker way to read the paused property. It is public for speed purposes. When
		 * setting the paused state, always use the regular "paused" property.
		 * 
		 * @private
		 **/
		public var cachedPaused:Boolean;
		
		/**
		 * Place to store any additional data you want.
		 */
		public var data:*;
		
		
		//-----------------------------------------------------------------------------------------
		// Constructor
		//-----------------------------------------------------------------------------------------
		
		/**
		 * @param duration
		 * @param tweenVars
		 */
		public function TweenBase(duration:Number = 0.0, tweenVars:TweenVars = null)
		{
			vars = tweenVars || new TweenVars();
			
			if (vars.isGSVars) vars = vars.vars;
			
			cachedDuration = cachedTotalDuration = duration;
			cachedTimeScale = isNaN(vars.timeScale) ? 1.0 : vars.timeScale;
			_delay = isNaN(vars.delay) ? 0.0 : vars.delay;
			active = (duration == 0.0 && _delay == 0.0 && vars.immediateRender);
			cachedTotalTime = cachedTime = 0.0;
			data = vars.data;
			
			if (!_classInitialized)
			{
				if (isNaN(Tween.rootFrame))
				{
					Tween.initClass();
					_classInitialized = true;
				}
				else
				{
					return;
				}
			}
			
			var timeline:TimelineBase = (vars.timeline is TimelineBase)
				? vars.timeline : vars.useFrames
				? Tween.rootFramesTimeline : Tween.rootTimeline;
			
			timeline.insert(this, timeline.cachedTotalTime);
			if (vars.reversed) cachedReversed = true;
			if (vars.paused) paused = true;
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Starts playing forward from the current position. (essentially unpauses and
		 * makes sure that it is not reversed)
		 */
		public function play():void
		{
			reversed = false;
			paused = false;
		}
		
		
		/**
		 * Pauses the tween/timeline.
		 */
		public function pause():void
		{
			paused = true;
		}
		
		
		/**
		 * Starts playing from the current position without altering direction (forward or
		 * reversed).
		 */
		public function resume():void
		{
			paused = false;
		}
		
		
		/**
		 * Restarts and begins playing forward.
		 * 
		 * @param includeDelay Determines whether or not the delay (if any) is honored in
		 *            the restart().
		 * @param suppressEvents If true, no events or callbacks will be triggered as the
		 *            "virtual playhead" moves to the new position (onComplete, onUpdate,
		 *            onReverseComplete, etc. of this tween/timeline and any of its child
		 *            tweens/timelines won't be triggered, nor will any of the associated
		 *            events be dispatched).
		 */
		public function restart(includeDelay:Boolean = false, suppressEvents:Boolean = true):void
		{
			reversed = false;
			paused = false;
			setTotalTime((includeDelay) ? -_delay : 0, suppressEvents);
		}
		
		
		/**
		 * Reverses smoothly, adjusting the startTime to avoid any skipping. After being
		 * reversed, it will play backwards, exactly opposite from its forward
		 * orientation, meaning that, for example, a tween's easing equation will appear
		 * reversed as well. If a tween/timeline plays for 2 seconds and gets reversed, it
		 * will play for another 2 seconds to return to the beginning.
		 * 
		 * @param forceResume If true, it will resume() immediately upon reversing.
		 *            Otherwise its paused state will remain unchanged.
		 */
		public function reverse(forceResume:Boolean = true):void
		{
			reversed = true;
			if (forceResume) paused = false;
			else if (gc) setEnabled(true, false);
		}
		
		
		/**
		 * Forces the tween/timeline to completion.
		 * 
		 * @param skipRender to skip rendering the final state of the tween, set
		 *            skipRender to true.
		 * @param suppressEvents If true, no events or callbacks will be triggered for
		 *            this render (like onComplete, onUpdate, onReverseComplete, etc.)
		 */
		public function complete(skipRender:Boolean = false, suppressEvents:Boolean = false):void
		{
			if (!skipRender)
			{
				// just to force the final render
				renderTime(totalDuration, suppressEvents, false);
				// renderTime() will call complete() again, so just return here.
				return;
			}
			if (timeline.autoRemoveChildren)
			{
				setEnabled(false, false);
			}
			else
			{
				active = false;
			}
			if (!suppressEvents)
			{
				if (vars.onComplete && cachedTotalTime >= cachedTotalDuration && !cachedReversed)
				{
					// note: remember that tweens can have a duration of zero in which case
					// their cachedTime and cachedDuration would always match. Also,
					// Timeline/Max instances with autoRemoveChildren may have a
					// cachedTotalTime that exceeds cachedTotalDuration because the children
					// were removed after the last render.
					vars.onComplete.apply(null, vars.completeParams);
				}
				else if (cachedReversed && cachedTotalTime == 0 && vars.onReverseComplete != null)
				{
					vars.onReverseComplete.apply(null, vars.reverseCompleteParams);
				}
			}
		}
		
		
		/**
		 * Clears any initialization data (like starting values in tweens) which can be
		 * useful if, for example, you want to restart it without reverting to any
		 * previously recorded starting values. When you invalidate() a tween/timeline, it
		 * will be re-initialized the next time it renders and its <code>vars</code>
		 * object will be re-parsed. The timing of the tween/timeline (duration,
		 * startTime, delay) will NOT be affected. Another example would be if you have a
		 * <code>TweenPro(mc, 1, {x:100, y:100})</code> that ran when mc.x and mc.y were
		 * initially at 0, but now mc.x and mc.y are 200 and you want them tween to 100
		 * again, you could simply <code>invalidate()</code> the tween and
		 * <code>restart()</code> it. Without invalidating first, restarting it would
		 * cause the values jump back to 0 immediately (where they started when the tween
		 * originally began). When you invalidate a timeline, it automatically invalidates
		 * all of its children.
		 */
		public function invalidate():void
		{
		}
		
		
		/**
		 * Disposes the tween or timeline and stops it immediately.
		 */
		public function dispose():void
		{
			setEnabled(false, false);
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Accessors
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Length of time in seconds (or frames for frames-based tweens/timelines) before
		 * the tween should begin. The tween's starting values are not determined until
		 * after the delay has expired (except in from() tweens)
		 */
		public function get delay():Number
		{
			return _delay;
		}
		public function set delay(v:Number):void
		{
			startTime += v - _delay;
			_delay = v;
		}
		
		
		/**
		 * Duration of the tween in seconds (or frames for frames-based tweens/timelines)
		 * not including any repeats or repeatDelays. <code>totalDuration</code>, by
		 * contrast, does include repeats and repeatDelays. If you alter the
		 * <code>duration</code> of a tween while it is in-progress (active), its
		 * <code>startTime</code> will automatically be adjusted in order to make the
		 * transition smoothly (without a sudden skip).
		 */
		public function get duration():Number
		{
			return cachedDuration;
		}
		public function set duration(v:Number):void
		{
			var ratio:Number = v / cachedDuration;
			cachedDuration = cachedTotalDuration = v;
			setDirtyCache(true);
			// true in case it's a TweenPro or TimelinePro that has
			// a repeat - we'll need to refresh the totalDuration.
			if (active && !cachedPaused && v != 0)
			{
				setTotalTime(cachedTotalTime * ratio, true);
			}
		}
		
		
		/**
		 * Duration of the tween in seconds (or frames for frames-based tweens/timelines)
		 * including any repeats or repeatDelays (which are only available on TweenPro and
		 * TimelinePro). <code>duration</code>, by contrast, does <b>NOT</b> include
		 * repeats and repeatDelays. So if a TweenPro's <code>duration</code> is 1 and it
		 * has a repeat of 2, the <code>totalDuration</code> would be 3.
		 */
		public function get totalDuration():Number
		{
			return cachedTotalDuration;
		}
		public function set totalDuration(v:Number):void
		{
			duration = v;
		}
		
		
		/**
		 * Most recently rendered time (or frame for frames-based tweens/timelines)
		 * according to its <code>duration</code>. <code>totalTime</code>, by contrast, is
		 * based on its <code>totalDuration</code> which includes repeats and
		 * repeatDelays. Since Tween and Timeline don't offer <code>repeat</code>
		 * and <code>repeatDelay</code> functionality, <code>currentTime</code> and
		 * <code>totalTime</code> will always be the same but in TweenPro or TimelinePro,
		 * they could be different. For example, if a TimelinePro instance has a duration
		 * of 5 a repeat of 1 (meaning its <code>totalDuration</code> is 10), at the end
		 * of the second cycle, <code>currentTime</code> would be 5 whereas
		 * <code>totalTime</code> would be 10. If you tracked both properties over the
		 * course of the tween, you'd see <code>currentTime</code> go from 0 to 5 twice
		 * (one for each cycle) in the same time it takes <code>totalTime</code> go from 0
		 * to 10.
		 */
		public function get currentTime():Number
		{
			return cachedTime;
		}
		public function set currentTime(v:Number):void
		{
			setTotalTime(v, false);
		}
		
		
		/**
		 * Most recently rendered time (or frame for frames-based tweens/timelines)
		 * according to its <code>totalDuration</code>. <code>currentTime</code>, by
		 * contrast, is based on its <code>duration</code> which does NOT include repeats
		 * and repeatDelays. Since Tween and Timeline don't offer
		 * <code>repeat</code> and <code>repeatDelay</code> functionality,
		 * <code>currentTime</code> and <code>totalTime</code> will always be the same but
		 * in TweenPro or TimelinePro, they could be different. For example, if a
		 * TimelinePro instance has a duration of 5 a repeat of 1 (meaning its
		 * <code>totalDuration</code> is 10), at the end of the second cycle,
		 * <code>currentTime</code> would be 5 whereas <code>totalTime</code> would be 10.
		 * If you tracked both properties over the course of the tween, you'd see
		 * <code>currentTime</code> go from 0 to 5 twice (one for each cycle) in the same
		 * time it takes <code>totalTime</code> go from 0 to 10.
		 */
		public function get totalTime():Number
		{
			return cachedTotalTime;
		}
		public function set totalTime(v:Number):void
		{
			setTotalTime(v, false);
		}
		
		
		/**
		 * Start time in seconds (or frames for frames-based tweens/timelines), according
		 * to its position on its parent timeline.
		 */
		public function get startTime():Number
		{
			return cachedStartTime;
		}
		public function set startTime(v:Number):void
		{
			if (timeline && (v != cachedStartTime || gc))
			{
				// ensures that any necessary re-sequencing of TweenBases
				// in the timeline occurs to make sure the rendering order is correct.
				timeline.insert(this, v - _delay);
			}
			else
			{
				cachedStartTime = v;
			}
		}
		
		
		/**
		 * Indicates the reversed state of the tween/timeline. This value is not affected
		 * by <code>yoyo</code> repeats and it does not take into account the reversed
		 * state of anscestor timelines. So for example, a tween that is not reversed
		 * might appear reversed if its parent timeline (or any ancenstor timeline) is
		 * reversed.
		 */
		public function get reversed():Boolean
		{
			return cachedReversed;
		}
		public function set reversed(v:Boolean):void
		{
			if (v == cachedReversed) return;
			cachedReversed = v;
			setTotalTime(cachedTotalTime, true);
		}
		
		
		/**
		 * Indicates the paused state of the tween/timeline. This does not take into
		 * account anscestor timelines. So for example, a tween that is not paused might
		 * appear paused if its parent timeline (or any ancenstor timeline) is paused.
		 */
		public function get paused():Boolean
		{
			return cachedPaused;
		}
		public function set paused(v:Boolean):void
		{
			if (v != cachedPaused && timeline)
			{
				if (v)
				{
					cachedPauseTime = timeline.rawTime;
				}
				else
				{
					cachedStartTime += timeline.rawTime - cachedPauseTime;
					cachedPauseTime = NaN;
					setDirtyCache(false);
				}
				cachedPaused = v;
				active = (!cachedPaused && cachedTotalTime > 0 && cachedTotalTime < cachedTotalDuration);
			}
			if (!v && gc)
			{
				setEnabled(true, false);
			}
		}
		
		
		//-----------------------------------------------------------------------------------------
		// Private Methods
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Renders the tween/timeline at a particular time (or frame number for
		 * frames-based tweens) WITHOUT changing its startTime. For example, if a tween's
		 * duration is 3, <code>renderTime(1.5)</code> would render it at the halfway
		 * finished point.
		 * 
		 * @private
		 * 
		 * @param time time in seconds (or frame number for frames-based tweens/timelines)
		 *            to render.
		 * @param suppressEvents If true, no events or callbacks will be triggered for
		 *            this render (like onComplete, onUpdate, onReverseComplete, etc.)
		 * @param force Normally the tween will skip rendering if the time matches the
		 *            cachedTotalTime (to improve performance), but if force is true, it
		 *            forces a render. This is primarily used internally for tweens with
		 *            durations of zero in Timeline/Max instances.
		 */
		public function renderTime(time:Number, suppressEvents:Boolean = false,
			force:Boolean = false):void
		{
		}
		
		
		/**
		 * If a tween/timeline is enabled, it is eligible to be rendered (unless it is
		 * paused). Setting enabled to false essentially removes it from its parent
		 * timeline and stops protecting it from garbage collection.
		 * 
		 * @private
		 * 
		 * @param enabled Enabled state of the tween/timeline
		 * @param ignoreTimeline By default, the tween/timeline will remove itself from
		 *            its parent timeline when it is disabled, and add itself when it is
		 *            enabled, but this parameter allows you to override that behavior.
		 * @return Boolean value indicating whether or not important properties may have
		 *         changed when the TweenBase was enabled/disabled. For example, when a
		 *         motionBlur (plugin) is disabled, it swaps out a BitmapData for the
		 *         target and may alter the alpha. We need to know this in order to
		 *         determine whether or not a new tween that is overwriting this one
		 *         should be re-initted() with the changed properties.
		 */
		public function setEnabled(enabled:Boolean, ignoreTimeline:Boolean = false):Boolean
		{
			gc = !enabled;
			if (enabled)
			{
				active = (!cachedPaused && cachedTotalTime > 0
					&& cachedTotalTime < cachedTotalDuration);
				if (!ignoreTimeline && cachedOrphan)
				{
					timeline.insert(this, cachedStartTime - _delay);
				}
			}
			else
			{
				active = false;
				if (!ignoreTimeline && !cachedOrphan)
				{
					timeline.remove(this, true);
				}
			}
			return false;
		}
		
		
		/**
		 * Sets the cacheIsDirty property of all anscestor timelines (and optionally this
		 * tween/timeline too). Setting the cacheIsDirty property to true forces any
		 * necessary recalculation of its cachedDuration and cachedTotalDuration
		 * properties and sorts the affected timelines' children TweenBases so that
		 * they're in the proper order next time the duration or totalDuration is
		 * requested. We don't just recalculate them immediately because it can be much
		 * faster to do it this way.
		 * 
		 * @private
		 * 
		 * @param includeSelf indicates whether or not this tween's cacheIsDirty property
		 *            should be affected.
		 */
		protected function setDirtyCache(includeSelf:Boolean = true):void
		{
			var tween:TweenBase = (includeSelf) ? this : timeline;
			while (tween)
			{
				tween.cacheIsDirty = true;
				tween = tween.timeline;
			}
		}


		/**
		 * Sort of like placing the local "playhead" at a particular totalTime and then
		 * aligning it with the parent timeline's "playhead" so that rendering continues
		 * from that point smoothly. This changes the cachedStartTime.
		 * 
		 * @private
		 * 
		 * @param time Time that should be rendered (includes any repeats and repeatDelays
		 *            for TimelinePro)
		 * @param suppressEvents If true, no events or callbacks will be triggered for
		 *            this render (like onComplete, onUpdate, onReverseComplete, etc.)
		 **/
		protected function setTotalTime(time:Number, suppressEvents:Boolean = false):void
		{
			if (timeline)
			{
				var tlTime:Number = (cachedPaused) ? cachedPauseTime : timeline.cachedTotalTime;
				if (cachedReversed)
				{
					var dur:Number = (cacheIsDirty) ? totalDuration : cachedTotalDuration;
					cachedStartTime = tlTime - ((dur - time) / cachedTimeScale);
				}
				else
				{
					cachedStartTime = tlTime - (time / cachedTimeScale);
				}
				if (!timeline.cacheIsDirty)
				{
					// for performance improvement. If the parent's cache is already dirty,
					// it already took care of marking the anscestors as dirty too, so skip
					// the function call here.
					setDirtyCache(false);
				}
				if (cachedTotalTime != time)
				{
					renderTime(time, suppressEvents, false);
				}
			}
		}
	}
}
