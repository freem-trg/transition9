/*******************************************************************************
 * Hydrax: haXe port of the PushButton Engine
 * Copyright (C) 2010 Dion Amago
 * For more information see http://github.com/dionjwa/Hydrax
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package transition9.geom;

import de.polygonal.core.math.Vec2;
import de.polygonal.ds.Cloneable;

import transition9.util.Equalable;

using transition9.geom.LineSegmentTools;
using transition9.geom.Vec2Tools;

class LineSegment 
	implements Equalable<LineSegment>, implements Cloneable<LineSegment>
{
	public var a :Vec2;
	public var b :Vec2;
	public var length (getLength, null) :Float;

	public var normalVector(getNormalVector, null) : Vec2;

	public static function closestPoint (a :Vec2, b :Vec2, p :Vec2) :Vec2
	{
		var closestPoint:Vec2 = new Vec2();
		distToLineSegment(a, b, p, closestPoint);
		return closestPoint;
	}

	public static function distanceLineSegments (p1 :Vec2, p2 :Vec2, p3 :Vec2, p4 :Vec2,
		pa :Vec2, pb :Vec2) :Float
	{
		// trace("p1=" + p1);
		// trace("p2=" + p2);
		// trace("p3=" + p3);
		// trace("p4=" + p4);
		var abs:Dynamic = Math.abs;
		var EPS:Float = 0.00000001;
		var mua:Float;
		var mub:Float;

		var p13:Vec2 = new Vec2();
		var p43:Vec2 = new Vec2();
		var p21:Vec2 = new Vec2();

		var d1343:Float;
		var d4321:Float;
		var d1321:Float;
		var d4343:Float;
		var d2121:Float;
		var numer:Float;
		var denom:Float;
		//		var mub :Number;

		p13.x = p1.x - p3.x;
		p13.y = p1.y - p3.y;
		//		p13.z = p1.z - p3.z;
		p43.x = p4.x - p3.x;
		p43.y = p4.y - p3.y;
		//		p43.z = p4.z - p3.z;
		if (abs(p43.x) < EPS && abs(p43.y) < EPS) {
			trace("here");
			return 0;
		}
		p21.x = p2.x - p1.x;
		p21.y = p2.y - p1.y;
		//		p21.z = p2.z - p1.z;
		if (abs(p21.x) < EPS && abs(p21.y) < EPS) {
			trace("here2");
			return 0;
		}

		d1343 = p13.x * p43.x + p13.y * p43.y; // + p13.z * p43.z;
		d4321 = p43.x * p21.x + p43.y * p21.y; // + p43.z * p21.z;
		d1321 = p13.x * p21.x + p13.y * p21.y; // + p13.z * p21.z;
		d4343 = p43.x * p43.x + p43.y * p43.y; // + p43.z * p43.z;
		d2121 = p21.x * p21.x + p21.y * p21.y; // + p21.z * p21.z;

		trace("d1343=" + d1343);
		trace("d4321=" + d4321);
		trace("d1321=" + d1321);
		trace("d4343=" + d4343);
		trace("d2121=" + d2121);

		denom = d2121 * d4343 - d4321 * d4321;
		if (abs(denom) < EPS) {
			trace("here3");
			return 0;
		}
		numer = d1343 * d4321 - d1321 * d4343;
		trace("numer=" + (d1343 * d4321) + " / " + (d1321 * d4343));

		mua = numer / denom;
		mub = (d1343 + d4321 * (mua)) / d4343;

		trace("numer=" + numer);
		trace("denom=" + denom);
		trace("mua=" + mua);
		trace("mub=" + mub);

		pa.x = p1.x + mua * p21.x;
		pa.y = p1.y + mua * p21.y;
		//		pa->z = p1.z + *mua * p21.z;
		pb.x = p3.x + mub * p43.x;
		pb.y = p3.y + mub * p43.y;
		//		pb.z = p3.z + *mub * p43.z;

		//		return(TRUE);
		trace(pa, pb);
		return Vec2Tools.distance(pa, pb);
	}

	/**
	 * Given a line segment AB and a point P, this function calculates the
	 * perpendicular distance between them.
	 * @param A the first point of the line segment
	 * @param B the 2nd point of the line segment
	 * @param P the point to check against
	 * @return the distance from P -> AB
	 *
	 * Original function by Pieter Iserbyt:
	 * http://local.wasp.uwa.edu.au/~pbourke.geom/pointline/DistancePoint.java
	 * from Paul Bourke's website:
	 * http://local.wasp.uwa.edu.au/~pbourke.geom/pointline/
	 *
	 */
	public static function distToLineSegment (A :Vec2, B :Vec2, P :Vec2,
		?closestPoint :Vec2 = null) :Float
	{
		return Math.sqrt(distToLineSegmentSq(A, B, P, closestPoint));
		//		var dx:Number=B.x-A.x;
		//		var dy:Number=B.y-A.y;
		//		if (dx==0&&dy==0) {
		//			B.x+=1;
		//			B.y+=1;
		//			dx=dy=1;
		//		}
		//		var u:Number = ((P.x - A.x) * dx + (P.y - A.y) * dy) / (dx * dx + dy * dy);
		//
		//		var closestX:Number;
		//		var closestY:Number;
		//		if (u<0) {
		//			closestX=A.x;
		//			closestY=A.y;
		//		} else if (u> 1) {
		//			closestX=B.x;
		//			closestY=B.y;
		//		} else {
		//			closestX=A.x+u*dx;
		//			closestY=A.y+u*dy;
		//		}
		//		if (closestPoint != null) {
		//			closestPoint.x = closestX;
		//			closestPoint.y = closestY;
		//		}
		//		dx=closestX-P.x;
		//		dy=closestY-P.y;
		//		return Math.sqrt(dx * dx +  dy * dy);
	}

	public static function distToLineSegmentSq (A :Vec2, B :Vec2, P :Vec2,
		?closestPoint :Vec2 = null) :Float
	{
		var dx = B.x - A.x;
		var dy = B.y - A.y;
		if (dx == 0 && dy == 0) {
			B.x += 1;
			B.y += 1;
			dx = dy = 1;
		}
		var u = ((P.x - A.x) * dx + (P.y - A.y) * dy) / (dx * dx + dy * dy);

		var closestX:Float;
		var closestY:Float;
		if (u < 0) {
			closestX = A.x;
			closestY = A.y;
		} else if (u > 1) {
			closestX = B.x;
			closestY = B.y;
		} else {
			closestX = A.x + u * dx;
			closestY = A.y + u * dy;
		}
		if (closestPoint != null) {
			closestPoint.x = closestX;
			closestPoint.y = closestY;
		}
		dx = closestX - P.x;
		dy = closestY - P.y;
		return dx * dx + dy * dy;

		//		var dx:Number=B.x-A.x;
		//		var dy:Number=B.y-A.y;
		//		if (dx==0&&dy==0) {
		//			B.x+=1;
		//			B.y+=1;
		//			dx=dy=1;
		//		}
		//		var u:Number = ((P.x - A.x) * dx + (P.y - A.y) * dy) / (dx * dx + dy * dy);
		//
		//		var closestX:Number;
		//		var closestY:Number;
		//		if (u<0) {
		//			closestX=A.x;
		//			closestY=A.y;
		//		} else if (u> 1) {
		//			closestX=B.x;
		//			closestY=B.y;
		//		} else {
		//			closestX=A.x+u*dx;
		//			closestY=A.y+u*dy;
		//		}
		//		dx=closestX-P.x;
		//		dy=closestY-P.y;
		//		return dx * dx +  dy * dy;
	}

	public static function isConnected (A :Vec2, B :Vec2, E :Vec2, F :Vec2) :Bool
	{
		return (A.equals(E) && !B.equals(F)) || (!A.equals(E) && B.equals(F)) || (A.equals(F) &&
			!B.equals(E)) || (!A.equals(F) && B.equals(E));
	}

	public static function isLinesIntersecting (A :Vec2, B :Vec2, E :Vec2,
		F :Vec2) :Bool
	{
		return lineIntersectLine(A, B, E, F) != null;
	}

	//---------------------------------------------------------------
	//Checks for intersection of Segment if as_seg is true.
	//Checks for intersection of Line if as_seg is false.
	//Return intersection of Segment "AB" and Segment "EF" as a Point
	//Return null if there is no intersection
	//Replacement for lineIntersection, which does not work
	//---------------------------------------------------------------
	public static function lineIntersectLine (A :Vec2, B :Vec2, E :Vec2, F :Vec2,
		?as_seg :Bool = true) :Vec2
	{
		var ip:Vec2;
		var a1:Float;
		var a2:Float;
		var b1:Float;
		var b2:Float;
		var c1:Float;
		var c2:Float;

		a1 = B.y - A.y;
		b1 = A.x - B.x;
		c1 = B.x * A.y - A.x * B.y;
		a2 = F.y - E.y;
		b2 = E.x - F.x;
		c2 = F.x * E.y - E.x * F.y;

		var denom = a1 * b2 - a2 * b1;
		if (denom == 0) {
			return null;
		}
		ip = new Vec2();
		ip.x = (b1 * c2 - b2 * c1) / denom;
		ip.y = (a2 * c1 - a1 * c2) / denom;

		//---------------------------------------------------
		//Do checks to see if intersection to endpoints
		//distance is longer than actual Segments.
		//Return null if it is with any.
		//---------------------------------------------------
		var distance:Dynamic = Vec2Tools.distance;
		if (as_seg) {
			if (distance(ip, B) > distance(A, B)) {
				return null;
			}
			if (distance(ip, A) > distance(A, B)) {
				return null;
			}

			if (distance(ip, F) > distance(E, F)) {
				return null;
			}
			if (distance(ip, E) > distance(E, F)) {
				return null;
			}
		}
		return ip;
	}

	public function new (x1 :Vec2, x2 :Vec2)
	{
		a = x1;
		b = x2;
	}

	inline function getLength ():Float
	{
		return Vec2Tools.distance(a, b);
	}

	function getNormal ():LineSegment
	{
		var dx = a.x - b.x;
		var dy = a.y - b.y;

		var midX = b.x + dx / 2;
		var midY = b.y + dy / 2;

		var A:Vec2 = new Vec2(midX + dy / 2, midY + -dx / 2);
		var B:Vec2 = new Vec2(midX - dy / 2, midY + dx / 2);
		return new LineSegment(A, B);
	}

	//Anticlockwise, from (0,0)
	function getNormalVector ():Vec2
	{
		var dx = a.x - b.x;
		var dy = a.y - b.y;

		var midX = b.x + dx / 2;
		var midY = b.y + dy / 2;

		var A:Vec2 = new Vec2(midX + dy / 2, midY + -dx / 2);
		A.x = midX - A.x;
		A.y = midY - A.y;
		return A;
	}

	public function clone () :LineSegment
	{
		return new LineSegment(a.clone(), b.clone());
	}
	
	public function equals (other :LineSegment) :Bool
	{
		return other.a.equals(a) && other.b.equals(b);
	}
	
	//	/**
	//	 * Given a line segment AB and a point P, this function calculates the
	//	 * perpendicular distance [Squared] between them to avoid the sqrt.
	//	 * @param A the first point of the line segment
	//	 * @param B the 2nd point of the line segment
	//	 * @param P the point to check against
	//	 * @return the distance from P -> AB
	//	 *
	//	 */
	//	public static function distToLineSegmentSq (A:Vec2, B:Vec2, P:Vec2) :Number
	//	{
	//		var dotA:Number = (P.x - A.x)*(B.x - A.x) + (P.y - A.y)*(B.y - A.y);
	//
	//		if (dotA <= 0) return Vec2Tools.distanceSq(A, P);
	//
	//		var dotB:Number = (P.x - B.x)*(A.x - B.x) + (P.y - B.y)*(A.y - B.y);
	//
	//		if (dotB <= 0) return Vec2Tools.distanceSq(B, P);
	//
	//		// .. Find closest point to P on line segment ...
	//		var point:Vec2 = B.subtract(A);
	//		point.scaleLocal(dotA);
	//		point.scaleLocal(1/(dotA+dotB));
	//		point.addLocal(A);
	//
	//		return Vec2Tools.distanceSq(P, point);
	//	}

	public function closestPointTo (P :Vec2) :Vec2
	{
		var closestPoint:Vec2 = new Vec2();
		distToLineSegment(a, b, P, closestPoint);
		return closestPoint;
	}

	public function dist (P :Vec2) :Float
	{
		return distToLineSegment(a, b, P);
	}

	public function distanceToLine (line :LineSegment) :Float
	{
		return Math.sqrt(distanceToLineSq(line));
	}

	public function distanceToLineSq (line :LineSegment) :Float
	{
		return Math.min(
			Math.min(distToLineSegmentSq(a, b, line.a), distToLineSegmentSq(a, b, line.b)),
			Math.min(distToLineSegmentSq(line.a, line.b, a), distToLineSegmentSq(line.a, line.b, b)));
	}

	public function distSq (P :Vec2) :Float
	{
		return distToLineSegmentSq(a, b, P);
	}

	public function equalToPoints (p1 :Vec2, p2 :Vec2) :Bool
	{
		return (a.equals(p1) && b.equals(p2)) || (a.equals(p2) && b.equals(p1));
	}

	public function intersectionPoint (line :LineSegment, ?as_seg :Bool = true) :Vec2
	{
		return lineIntersectLine(a, b, line.a, line.b, as_seg);
	}

	public function intersectionPointLinePoints (v1 :Vec2, v2 :Vec2, ?as_seg :Bool =
		true) :Vec2
	{
		return lineIntersectLine(a, b, v1, v2, as_seg);
	}

	public function isIntersected (v1 :Vec2, v2 :Vec2) :Bool
	{
		var intersectionPoint:Vec2 = lineIntersectLine(a, b, v1, v2, true);
		return intersectionPoint != null;
	}

	public function isIntersectedByLine (line :LineSegment) :Bool
	{
		var intersectionPoint:Vec2 = lineIntersectLine(a, b, line.a, line.b, true);
		return intersectionPoint != null;
	}

	public function reversePoints () :Void
	{
		var x:Vec2 = a;
		a = b;
		b = x;
	}

	public function rotate (angle :Float) :LineSegment
	{
		return this.clone().rotateLocal(angle);
	}

	public function rotateLocal (angle :Float) :LineSegment
	{
		var mid:Vec2 = getMidpoint();
		a.subtractLocal(mid).rotateLocal(angle);
		b.subtractLocal(mid).rotateLocal(angle);
		return this;
	}

	public function toString () :String
	{
		return "Line [" + a + ", " + b + "]";
	}
}
