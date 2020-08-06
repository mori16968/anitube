var mySwiper = new Swiper('.swiper-container', {
  effect: 'coverflow',
  initialSlide: 0,
  spaceBetween: 10,
  centeredSlides: true,
  scrollbar: {
		el: '.swiper-scrollbar',
		hide: false,
		draggable: true
	},
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
});