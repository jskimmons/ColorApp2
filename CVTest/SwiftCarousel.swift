/*
 * Copyright (c) 2015 Droids on Roids LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

@objc public protocol SwiftCarouselDelegate {
    optional func didSelectItem(item item: UIView, index: Int) -> UIView?
    optional func didDeselectItem(item item: UIView, index: Int) -> UIView?
    @objc optional func didScroll(toOffset offset: CGPoint) -> Void
    @objc optional func willBeginDragging(withOffset offset: CGPoint) -> Void
    @objc optional func didEndDragging(withOffset offset: CGPoint) -> Void
}

public enum SwiftCarouselResizeType {
    // WithoutResizing is adding frames as they are.
    // Parameter = spacing between UIViews.
    // !!You need to pass correct frame sizes as items!!
    case WithoutResizing(CGFloat)
    
    // VisibleItemsPerPage will try to fit the number of items you specify
    // in the whole screen (will resize them of course).
    // Parameter = number of items visible on screen.
    case VisibleItemsPerPage(Int)
    
    // FloatWithSpacing will use sizeToFit() on your views to correctly place images
    // It is helpful for instance with UILabels (Example1 in Examples folder).
    // Parameter = spacing between UIViews.
    case FloatWithSpacing(CGFloat)
}

public class SwiftCarousel: UIView, UIScrollViewDelegate {
    private var maxVelocity: CGFloat = 100.0
    private var shouldScroll: Bool = false
    private var shouldScrollToPosition: CGFloat = 0.0
    private var myContext = 0
    
    //MARK: - Properties
    private var originalChoicesNumber: Int = 0
    private var choices: Array<UIView> = []
    private var scrollView = UIScrollView()
    private var spacing: Double = 0.0
    private var currentSelectedIndex: Int?
    private var currentRealSelectedIndex: Int?
    public var delegate: SwiftCarouselDelegate?
    
    public var resizeType: SwiftCarouselResizeType = .WithoutResizing(0) {
        didSet {
            setupViews(views: choices)
        }
    }
    
    public var defaultSelectedIndex: Int? {
        didSet {
            if (defaultSelectedIndex! < 0) {
                defaultSelectedIndex = nil
            }
        }
    }
    
    public var selectedIndex: Int? {
        let view = viewAtLocation(touchLocation: CGPoint(x: scrollView.contentOffset.x + scrollView.frame.width / 2.0, y: scrollView.frame.minY))
        guard var index = choices.index(where: { $0 == view }) else {
            return nil
        }
        
        while index >= originalChoicesNumber {
            index -= originalChoicesNumber
        }
        
        return index
    }
    
    private var realSelectedIndex: Int? {
        let view = viewAtLocation(touchLocation: CGPoint(x: scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame) / 2.0, y: CGRectGetMinY(scrollView.frame)))
        guard let index = choices.indexOf({ $0 == view }) else {
            return nil
        }
        
        return index
    }
    
    public var items: Array<UIView> {
        get {
            return Array<UIView>(choices[choices.count/3..<(choices.count/3 + originalChoicesNumber)])
        }
        set {
            originalChoicesNumber = newValue.count
            (0..<3).forEach { counter in
                let newViews: Array<UIView> = newValue.map { choice in
                    // Return original view if middle section
                    if counter == 1 {
                        return choice
                    } else {
                        return choice.copyView()
                    }
                }
                self.choices.append(contentsOf: newViews)
            }
            setupViews(views: choices)
        }
    }
    
    //MARK: - Inits
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public convenience init(frame: CGRect, choices: Array<UIView>) {
        self.init(frame: frame)
        setup()
        items = choices
    }
    
    //MARK: - Setups
    private func setup() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: .alignAllCenterY, metrics: nil, views: ["scrollView": scrollView]))
        
        scrollView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
    }
    
    private func setupViews(views: Array<UIView>) {
        var x: CGFloat = 0.0
        if case .FloatWithSpacing(_) = resizeType {
            views.forEach { $0.sizeToFit() }
        }
        
        views.forEach { choice in
            var additionalSpacing: CGFloat = 0.0
            switch resizeType {
            case .WithoutResizing(let spacing): additionalSpacing = spacing
            case .FloatWithSpacing(let spacing): additionalSpacing = spacing
            case .VisibleItemsPerPage(let visibleItems):
                choice.frame.size.width = scrollView.frame.width/CGFloat(visibleItems)
                if (choice.frame.height > 0) {
                    let aspectRatio: CGFloat = choice.frame.width/choice.frame.height
                    choice.frame.size.height = floor(choice.frame.width * aspectRatio) > frame.height ? frame.height : floor(choice.frame.width*aspectRatio)
                } else {
                    choice.frame.size.height = frame.height
                }
            }
            choice.frame.origin.x = x
            x += choice.frame.width + additionalSpacing
        }
        
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        views.forEach { scrollView.addSubview($0) }
        layoutIfNeeded()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var width: CGFloat = 0.0
        switch resizeType {
        case .FloatWithSpacing(_), .WithoutResizing(_):
            width = choices.last!.frame.maxX
        case .VisibleItemsPerPage(_):
            width = choices.reduce(0.0) { $0 + $1.frame.width }
        }
        
        scrollView.contentSize = CGSize(width: width, height: frame.height)
        maxVelocity = scrollView.contentSize.width / 6.0
        
        // Center the view
        if defaultSelectedIndex != nil {
            selectItem(choice: defaultSelectedIndex!, animated: true)
        } else {
            selectItem(choice: 0, animated: false)
        }
    }
    
    //MARK: - UIScrollViewDelegate
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        didSelectItem()
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        didSelectItem()
    }
    
    private func didSelectItem() {
        guard let selectedIndex = self.selectedIndex, let realSelectedIndex = self.realSelectedIndex else {
            return
        }
        
        didDeselectItem()
        delegate?.didSelectItem?(item: choices[realSelectedIndex], index: selectedIndex)
        
        currentSelectedIndex = selectedIndex
        currentRealSelectedIndex = realSelectedIndex
    }
    
    private func didDeselectItem() {
        guard let currentRealSelectedIndex = self.currentRealSelectedIndex, let currentSelectedIndex = self.currentSelectedIndex else {
            return
        }
        
        delegate?.didDeselectItem?(item: choices[currentRealSelectedIndex], index: currentSelectedIndex)
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        delegate?.willBeginDragging?(withOffset: scrollView.contentOffset)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.didEndDragging?(withOffset: scrollView.contentOffset)
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var velocity = velocity.x * 300.0
        if velocity >= maxVelocity {
            velocity = maxVelocity
        } else if velocity <= -maxVelocity {
            velocity = -maxVelocity
        }
        
        var targetX = scrollView.contentOffset.x + scrollView.frame.width / 2.0 + velocity
        if (targetX > scrollView.contentSize.width || targetX < 0.0) {
            targetX = scrollView.contentSize.width / 3.0 + velocity
        }
        
        let choiceView = nearestViewAtLocation(touchLocation: CGPoint(x: targetX, y: scrollView.frame.minY))
        targetContentOffset.memory.x = choiceView.center.x - scrollView.frame.width / 2.0
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let _ = change?[NSKeyValueChangeNewKey], keyPath == "contentOffset" {
            let newOffset = scrollView.contentOffset
            if shouldScroll {
                if case (shouldScrollToPosition-10..<shouldScrollToPosition+10) = newOffset.x {
                    shouldScroll = false
                }
            }
            
            if !shouldScroll {
                var newOffsetX: CGFloat!
                if (newOffset.x >= scrollView.contentSize.width * 2.0 / 3.0) {
                    newOffsetX = newOffset.x - scrollView.contentSize.width / 3.0
                } else if (scrollView.bounds.maxX <= scrollView.contentSize.width / 3.0) { // First part
                    newOffsetX = newOffset.x + scrollView.contentSize.width * 3.0
                }
                guard newOffsetX != nil && newOffsetX > 0 else {
                    return
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.shouldScroll = true
                    self.shouldScrollToPosition = newOffsetX
                    self.scrollView.contentOffset.x = newOffsetX
                    self.delegate?.didScroll?(toOffset: self.scrollView.contentOffset)
                })
            }
        }
    }
    
    //MARK: - Helpers
    private func refreshChoices() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func willChangePart(point: CGPoint) -> Bool {
        if (point.x >= scrollView.contentSize.width * 2.0 / 3.0 ||
            point.x <= scrollView.contentSize.width / 3.0) {
            return true
        }
        
        return false
    }
    
    private func viewAtLocation(touchLocation: CGPoint) -> UIView? {
        for subview in scrollView.subviews where subview.frame.contains(touchLocation) {
            return subview
        }
        
        return nil
    }
    
    private func nearestViewAtLocation(touchLocation: CGPoint) -> UIView {
        if let newView = viewAtLocation(touchLocation: touchLocation) {
            return newView
        }
        
        // Now check left and right margins to nearest views
        var step: CGFloat = 1.0
        switch resizeType {
        case .FloatWithSpacing(let spacing):
            step = spacing
        case .WithoutResizing(let spacing):
            step = spacing
        default: break
        }
        
        var targetX = touchLocation.x
        
        // Left
        var leftView: UIView?
        repeat {
            targetX -= step
            leftView = viewAtLocation(touchLocation: CGPoint(x: targetX, y: touchLocation.y))
        } while (leftView == nil)
        let leftMargin = touchLocation.x - leftView!.frame.maxX
        
        // Right
        var rightView: UIView?
        repeat {
            targetX += step
            rightView = viewAtLocation(touchLocation: CGPoint(x: targetX, y: touchLocation.y))
        } while (rightView == nil)
        let rightMargin = rightView!.frame.minX - touchLocation.x
        
        if rightMargin < leftMargin {
            return rightView!
        } else {
            return leftView!
        }
    }
    
    public func selectItem(choice: Int, animated: Bool) {
        guard choice < choices.count / 3 else {
            return
        }
        var min: Int = originalChoicesNumber
        var index: Int = choice
        if let realSelectedIndex = self.realSelectedIndex {
            for choiceIndex in choice.stride(from: 0, to: choices.count, by: originalChoicesNumber) {
                if abs(realSelectedIndex - choiceIndex) < min {
                    index = choiceIndex
                    min = abs(realSelectedIndex - choiceIndex)
                }
            }
        }
        
        let choiceView = choices[index]
        let x = choiceView.center.x - scrollView.frame.width / 2.0
        scrollView.setContentOffset(CGPoint(x: x, y: scrollView.contentOffset.y), animated: animated)
        if !animated {
            didSelectItem()
        }
    }
}

extension UIView {
    func copyView() -> UIView {
        let serialized = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: serialized) as! UIView
    }
}









